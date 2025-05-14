import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';

class ProgressLoader extends StatelessWidget {
  final double? value; // Pour la progression (0.0 - 1.0), null pour indéterminé
  final bool isLinear;
  final String? message;

  const ProgressLoader({
    super.key,
    this.value,
    this.isLinear = false,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLinear)
            LinearProgressIndicator(
              value: value,
              backgroundColor: AppColors.secondaryColor,
              color: AppColors.primaryColor,
            )
          else
            CircularProgressIndicator(
              value: value,
              backgroundColor: AppColors.secondaryColor,
              color: AppColors.primaryColor,
            ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                message!,
                style: const TextStyle(color: AppColors.textColorSecondary),
              ),
            ),
        ],
      ),
    );
  }
}