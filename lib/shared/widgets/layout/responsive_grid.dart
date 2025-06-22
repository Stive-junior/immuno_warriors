import 'package:flutter/material.dart';

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double minWidth;
  final double spacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minWidth = 150.0,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth / (minWidth + spacing)).floor();
        return GridView.count(
          crossAxisCount: crossAxisCount > 0 ? crossAxisCount : 1,
          padding: EdgeInsets.zero,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: 1.0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: children,
        );
      },
    );
  }
}