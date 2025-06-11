import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Displays the research interface, optionally for a specific node.
class ResearchScreen extends StatelessWidget {
  final String? nodeId;

  const ResearchScreen({super.key, this.nodeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          nodeId != null
              ? '${AppStrings.research} - Node $nodeId'
              : AppStrings.research,
        ),
        backgroundColor: AppColors.cardBackground,
      ),
      body: Center(
        child: Text(
          nodeId != null ? 'Research Node: $nodeId' : AppStrings.research,
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
