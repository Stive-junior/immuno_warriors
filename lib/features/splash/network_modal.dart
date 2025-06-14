import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import 'package:immuno_warriors/features/auth/providers/auth_provider.dart';
import 'package:immuno_warriors/features/splash/splash_screen_state.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';
import 'package:immuno_warriors/shared/widgets/buttons/holo.dart';
import 'package:immuno_warriors/shared/widgets/buttons/icon_button.dart'
    as IconButton;

void showNetworkModal(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (context) => const NetworkModal(),
  );
}

class NetworkModal extends ConsumerStatefulWidget {
  const NetworkModal({super.key});

  @override
  ConsumerState<NetworkModal> createState() => _NetworkModalState();
}

class _NetworkModalState extends ConsumerState<NetworkModal> {
  final TextEditingController _urlController = TextEditingController();
  String _testResult = '';
  bool _isTesting = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    final currentUrl = ref.read(splashScreenProvider).currentUrl;
    _urlController.text = currentUrl.isNotEmpty ? currentUrl : 'https://';
    _urlController.addListener(_onUrlChanged);
  }

  void _onUrlChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _testUrl(_urlController.text, auto: true);
    });
  }

  Future<void> _testUrl(String url, {bool auto = false}) async {
    if (!mounted) return;
    if (!_isValidUrl(url)) {
      setState(() {
        _testResult = const JsonEncoder.withIndent('  ').convert({
          'error': 'URL invalide',
          'timestamp': DateTime.now().toIso8601String(),
        });
        _isTesting = false;
      });
      AppLogger.error('URL invalide dans NetworkModal : $url');
      return;
    }

    setState(() {
      _isTesting = !auto;
      _testResult = auto ? _testResult : 'Test en cours...';
    });

    try {
      final networkService = ref.read(networkServiceProvider);
      final dioClient = ref.read(dioClientProvider);

      if (auto) {
        // Test automatique : vérifier la joignabilité
        final isReachable = await networkService.networkInfo.canHandleRequests(
          url,
        );
        if (!mounted) return;

        final result = {
          'url': url,
          'reachable': isReachable,
          'timestamp': DateTime.now().toIso8601String(),
        };

        setState(() {
          _testResult = const JsonEncoder.withIndent('  ').convert(result);
          _isTesting = false;
        });
      } else {
        // Test manuel : effectuer une requête HTTP GET
        final response = await dioClient.get('$url/api');
        if (!mounted) return;

        final result = {
          'url': url,
          'statusCode': response.statusCode,
          'data': response.data,
          'timestamp': DateTime.now().toIso8601String(),
        };

        setState(() {
          _testResult = const JsonEncoder.withIndent('  ').convert(result);
          _isTesting = false;
        });

        // Définir l'URL si la requête réussit
        networkService.setBaseUrl(url);
        AppLogger.info(
          'Requête réussie pour $url : ${response.statusCode}',
          stackTrace: StackTrace.current,
        );
      }
    } catch (e) {
      if (!mounted) return;
      final errorResult = {
        'url': url,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
      setState(() {
        _testResult = const JsonEncoder.withIndent('  ').convert(errorResult);
        _isTesting = false;
      });
      AppLogger.error(
        'Erreur test URL $url : $e',
        stackTrace: StackTrace.current,
      );
    }
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  @override
  void dispose() {
    _urlController.removeListener(_onUrlChanged);
    _urlController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: size.width * 0.80,
        constraints: BoxConstraints(maxHeight: size.height * 0.5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primaryColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.25),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.network_wifi,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  FuturisticText(
                    'Configurer l\'URL',
                    size: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColorPrimary,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        labelText: 'URL',
                        labelStyle: const TextStyle(
                          color: AppColors.textColorSecondary,
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundColor.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: AppColors.secondaryColor,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                      style: const TextStyle(
                        color: AppColors.textColorPrimary,
                        fontSize: 12,
                      ),
                      keyboardType: TextInputType.url,
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton.IconButton.filled(
                    icon: _isTesting ? Icons.hourglass_empty : Icons.play_arrow,
                    onPressed:
                        _isTesting ? null : () => _testUrl(_urlController.text),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 120,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.4),
                  ),
                ),
                child: SingleChildScrollView(
                  child: FuturisticText(
                    _testResult.isEmpty ? 'Aucun résultat' : _testResult,
                    size: 10,
                    color: AppColors.textColorSecondary,
                    maxLines: null,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              HolographicButton(
                onPressed: () => Navigator.pop(context),
                width: null,
                height: 36,
                child: FuturisticText(
                  'Fermer',
                  size: 12,
                  color: AppColors.textColorPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
