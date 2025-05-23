import 'package:flutter/material.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';

class FuturisticText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final List<Shadow>? shadows;

  const FuturisticText(
      this.text, {
        super.key,
        this.size,
        this.fontWeight,
        this.color,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.letterSpacing,
        this.shadows,
      });

  @override
  Widget build(BuildContext context) {
    final TextStyle defaultStyle = AppStyles.bodyMedium.copyWith(
      fontFamily: 'MIXONE',
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      shadows: shadows,
    );

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: defaultStyle,
    );
  }
}