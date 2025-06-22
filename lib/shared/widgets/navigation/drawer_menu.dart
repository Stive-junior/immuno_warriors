import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';

class DrawerMenu extends StatelessWidget {
  final List<DrawerItem> items;

  const DrawerMenu({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.secondaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Center(
              child: Text(
                'ImmunoWarriors',
                style: AppStyles.titleLarge.copyWith(color: AppColors.textColorPrimary),
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textColorPrimary),
      title: Text(text, style: AppStyles.bodyLarge),
      onTap: onTap,
    );
  }
}