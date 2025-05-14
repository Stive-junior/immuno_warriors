import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';

class ShimmerLoader extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoader({
    Key? key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.secondaryColor.withOpacity(0.5),
      highlightColor: highlightColor ?? AppColors.interfaceColorLight.withOpacity(0.2),
      child: child,
    );
  }
}