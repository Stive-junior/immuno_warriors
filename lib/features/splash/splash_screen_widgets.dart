
import 'package:flutter/material.dart';
import 'package:immuno_warriors/core/constants/app_strings.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/futuristic_text.dart';
import 'package:immuno_warriors/shared/widgets/buttons/holo.dart';

class MiniInputDialog extends StatefulWidget {
  final String initialUrl;
  final void Function(String) onSubmit;

  const MiniInputDialog({
    super.key,
    required this.initialUrl,
    required this.onSubmit,
  });

  @override
  State<MiniInputDialog> createState() => _MiniInputDialogState();
}

class _MiniInputDialogState extends State<MiniInputDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialUrl;
    _controller.addListener(_validateUrl);
  }

  void _validateUrl() {
    final url = _controller.text.trim();
    setState(() {
      _isValid = _isValidUrl(url);
    });
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.host.isNotEmpty && uri.host != 'localhost';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FuturisticText(
              'Entrer l\'URL réseau',
              size: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textColorPrimary,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: AppStrings.emailHint,
                labelStyle: const TextStyle(
                  color: AppColors.textColorSecondary,
                  fontSize: 11,
                ),
                filled: true,
                fillColor: AppColors.backgroundColor.withOpacity(0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: _isValid ? AppColors.primaryColor.withOpacity(0.3) : AppColors.errorColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: _isValid ? AppColors.primaryColor.withOpacity(0.3) : AppColors.errorColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.secondaryColor,
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                errorText: _isValid ? null : AppStrings.invalidEmail,
              ),
              style: const TextStyle(
                color: AppColors.textColorPrimary,
                fontSize: 11,
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 12),
            HolographicButton(
              onPressed: _isValid ? () => widget.onSubmit(_controller.text.trim()) : null,
              width: null,
              height: 36,
              child: FuturisticText(
                AppStrings.confirm,
                size: 12,
                color: AppColors.textColorPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VirusButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double width;
  final Widget child;

  const VirusButton({
    super.key,
    required this.onPressed,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: width,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                AppColors.virusGreen.withOpacity(0.3),
                AppColors.secondaryColor.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: AppColors.virusGreen.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: AppColors.virusGreen.withOpacity(0.15),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
