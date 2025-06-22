import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Displays the leaderboard interface.
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: AppColors.cardBackground,
      ),
      body: Center(
        child: Text(
          'Leaderboard',
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
