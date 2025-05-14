import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';

class ListTileWidget extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final EdgeInsets? contentPadding;

  const ListTileWidget({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.shape,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: shape is CircleBorder ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: shape is RoundedRectangleBorder ? (shape as RoundedRectangleBorder).borderRadius : null,
      ),
      child: ListTile(
        leading: leading,
        title: Text(title, style: AppStyles.bodyLarge),
        subtitle: subtitle != null ? Text(subtitle!, style: AppStyles.bodyMedium) : null,
        trailing: trailing,
        onTap: onTap,
        contentPadding: contentPadding,
      ),
    );
  }
}