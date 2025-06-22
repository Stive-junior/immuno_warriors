import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Displays the multiplayer interface for a specific game.
class MultiplayerScreen extends StatelessWidget {
  final String gameId;

  const MultiplayerScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Multiplayer: $gameId'),
        backgroundColor: AppColors.cardBackground,
      ),
      body: Center(
        child: Text(
          'Multiplayer Game: $gameId',
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
