import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';

class DataCard extends StatelessWidget {
  final String title;
  final List<DataCardItem> items;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Border? border;

  const DataCard({
    super.key,
    required this.title,
    required this.items,
    this.padding,
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
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(1, 3),
          ),
        ],
        border: border,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppStyles.titleSmall),
            const SizedBox(height: 8.0),
            ...items,
          ],
        ),
      ),
    );
  }
}

class DataCardItem extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle; // Style personnalisable pour le label
  final TextStyle? valueStyle; // Style personnalisable pour la valeur

  const DataCardItem({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle ?? AppStyles.bodyMedium),
          Text(value, style: valueStyle ?? AppStyles.bodyMedium.copyWith(color: AppColors.primaryColor)),
        ],
      ),
    );
  }
}