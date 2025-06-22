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
import 'package:immuno_warriors/shared/widgets/buttons/icon_button.dart' as IconButton;

import '../../core/constants/app_strings.dart';

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

class _NetworkModalState extends ConsumerState<NetworkModal> with SingleTickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  String _testResult = '';
  bool _isTesting = false;
  Timer? _debounceTimer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    final currentUrl = ref.read(splashScreenProvider).currentUrl;
    _urlController.text = currentUrl.isNotEmpty ? currentUrl : 'https://';
    _urlController.addListener(_onUrlChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutSine),
    );

    _animationController.forward();

    if (currentUrl.isEmpty) {
      setState(() {
        _testResult = const JsonEncoder.withIndent('  ').convert({
          'message': AppStrings.errorMessage,
          'timestamp': DateTime.now().toIso8601String(),
        });
      });
    }
  }

  void _onUrlChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _testUrl(_urlController.text, auto: true);
    });
  }

  Future<void> _testUrl(String url, {bool auto = false}) async {
    if (!mounted) return;
    if (!_isValidUrl(url)) {
      setState(() {
        _testResult = const JsonEncoder.withIndent('  ').convert({
          'error': AppStrings.invalidEmail,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _isTesting = false;
      });
      AppLogger.error('URL invalide dans NetworkModal : $url');
      return;
    }

    setState(() {
      _isTesting = !auto;
      _testResult = auto ? _testResult : AppStrings.loading;
    });

    try {
      final networkService = ref.read(networkServiceProvider);
      final dioClient = ref.read(dioClientProvider);

      if (auto) {
        final isReachable = await networkService.networkInfo.canHandleRequests(url);
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
        networkService.setBaseUrl(url);
        final response = await dioClient.get('/auth');
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

        if (response.statusCode == 200) {
          ref.read(splashScreenProvider.notifier).retry(context);
          AppLogger.info('Requête réussie pour $url : ${response.statusCode}');
        }
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
      AppLogger.error('Erreur test URL $url : $e');
    }
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty;
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _urlController.removeListener(_onUrlChanged);
    _urlController.dispose();
    _debounceTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: maxHeight * 0.7, // Limit dialog height to 70% of available space
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.2),
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
                        Icon(
                          Icons.network_wifi,
                          color: AppColors.secondaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        FuturisticText(
                          'Network URL Setup',
                          size: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColorPrimary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        hintText: 'Enter URL (e.g., https://api.example.com)',
                        hintStyle: TextStyle(
                          color: AppColors.textColorSecondary.withOpacity(0.6),
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundColor.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        suffixIcon: _isTesting
                            ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.secondaryColor,
                          ),
                        )
                            : null,
                      ),
                      style: const TextStyle(
                        color: AppColors.textColorPrimary,
                        fontSize: 14,
                      ),
                      keyboardType: TextInputType.url,
                      onTap: _hideKeyboard,
                    ),
                    const SizedBox(height: 12),
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: HolographicButton(
                            onPressed: _isTesting
                                ? null
                                : () {
                              _hideKeyboard();
                              _testUrl(_urlController.text);
                            },
                            width: double.infinity,
                            height: 40, // Reduced height
                            child: FuturisticText(
                              _isTesting ? 'Testing...' : 'Test URL',
                              size: 14,
                              color: AppColors.textColorPrimary,
                            ),
                          ),
                        );
                      },
                    ),
                    if (_testResult.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.3),
                          ),
                        ),
                        constraints: BoxConstraints(
                          maxHeight: maxHeight * 0.25, // Limit result height
                        ),
                        child: SingleChildScrollView(
                          child: FuturisticText(
                            _testResult,
                            size: 12,
                            color: AppColors.textColorSecondary,
                            maxLines: null,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: FuturisticText(
                          'Close',
                          size: 14,
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
