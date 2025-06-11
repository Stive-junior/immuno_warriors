import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// Displays the threat scanner interface.
class ThreatScannerScreen extends StatelessWidget {
  const ThreatScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.threatScannerTitle),
        backgroundColor: AppColors.cardBackground,
      ),
      body: Center(
        child: Text(
          AppStrings.threatScannerTitle,
          style: TextStyle(
            color: AppColors.text,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
