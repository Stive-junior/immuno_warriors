// shared/widgets/common/action_button.dart
import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';

class ActionButton extends StatelessWidget {
  final String? imageAsset;
  final IconData fallbackIcon;
  final String tooltip;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    this.imageAsset,
    required this.fallbackIcon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.backgroundColor.withOpacity(0.8),
            border: Border.all(color: AppColors.textColorSecondary, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.virusGreen.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child:
                imageAsset != null
                    ? Image.asset(
                      imageAsset!,
                      width: 24,
                      height: 24,
                      errorBuilder:
                          (context, error, stackTrace) => Icon(
                            fallbackIcon,
                            color: AppColors.textColorPrimary,
                            size: 24,
                          ),
                    )
                    : Icon(
                      fallbackIcon,
                      color: AppColors.textColorPrimary,
                      size: 24,
                    ),
          ),
        ),
      ),
    );
  }
}
