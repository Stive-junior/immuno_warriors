import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

/// Displays the threat scanner interface.
class CombatDetailScreen extends StatelessWidget {
  const CombatDetailScreen({super.key, required String combatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.bioForgeTitle),
        backgroundColor: AppColors.cardBackground,
      ),
      body: Center(
        child: Text(
          AppStrings.bioForgeTitle,
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

