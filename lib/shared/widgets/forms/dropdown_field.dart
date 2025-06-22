import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';

class DropdownField<T> extends StatelessWidget {
  final String labelText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isExpanded;

  const DropdownField({
    super.key,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      items: items,
      onChanged: onChanged,
      value: value,
      validator: validator,
      isExpanded: isExpanded,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.errorColor),
        ),
      ),
      style: AppStyles.bodyMedium,
      dropdownColor: AppColors.secondaryColor,
    );
  }
}