import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      backgroundColor: AppColors.secondaryColor,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.textColorSecondary,
      selectedLabelStyle: AppStyles.bodySmall,
      unselectedLabelStyle: AppStyles.bodySmall,
      type: BottomNavigationBarType.fixed, // Ou shifting pour un effet différent
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 8.0,
    );
  }
}