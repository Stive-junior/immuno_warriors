import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';
import 'package:immuno_warriors/shared/ui/screen_utils.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? elevation;
  final Border? border;
  final double? borderRadiusFactor;

  const InfoCard({
    super.key,
    required this.title,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.border,
    this.borderRadiusFactor = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(ScreenUtils.getRelativeWidth(context, borderRadiusFactor!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
        border: border,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(ScreenUtils.getRelativeWidth(context, 4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppStyles.titleSmall.copyWith(fontSize: ScreenUtils.isSmallScreen(context) ? 16 : 18)),
            SizedBox(height: ScreenUtils.getRelativeHeight(context, 1)),
            child,
          ],
        ),
      ),
    );
  }
}