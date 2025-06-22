import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;
  final Widget? icon;
  final Color? backgroundColor;
  final Border? border;

  const ActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(3, 5),
          ),
        ],
        border: border,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: icon!,
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppStyles.titleSmall),
                    const SizedBox(height: 8.0),
                    Text(description, style: AppStyles.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppColors.textColorSecondary),
            ],
          ),
        ),
      ),
    );
  }
}