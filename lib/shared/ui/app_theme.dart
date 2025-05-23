import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';
import 'package:immuno_warriors/shared/ui/app_styles.dart';

import '../../core/constants/app_assets.dart';


class _ImmunoWarriorsTheme extends ThemeExtension<_ImmunoWarriorsTheme> {
  final Color pathogenColor;
  final Color antibodyColor;
  final Color biohazardColor;
  final Color dnaColor;
  final Color glowEffect;

  const _ImmunoWarriorsTheme({
    required this.pathogenColor,
    required this.antibodyColor,
    required this.biohazardColor,
    required this.dnaColor,
    required this.glowEffect,
  });

  @override
  ThemeExtension<_ImmunoWarriorsTheme> copyWith({
    Color? pathogenColor,
    Color? antibodyColor,
    Color? biohazardColor,
    Color? dnaColor,
    Color? glowEffect,
  }) {
    return _ImmunoWarriorsTheme(
      pathogenColor: pathogenColor ?? this.pathogenColor,
      antibodyColor: antibodyColor ?? this.antibodyColor,
      biohazardColor: biohazardColor ?? this.biohazardColor,
      dnaColor: dnaColor ?? this.dnaColor,
      glowEffect: glowEffect ?? this.glowEffect,
    );
  }

  @override
  ThemeExtension<_ImmunoWarriorsTheme> lerp(
      covariant ThemeExtension<_ImmunoWarriorsTheme>? other,
      double t,
      ) {
    if (other is! _ImmunoWarriorsTheme) {
      return this;
    }
    return _ImmunoWarriorsTheme(
      pathogenColor: Color.lerp(pathogenColor, other.pathogenColor, t)!,
      antibodyColor: Color.lerp(antibodyColor, other.antibodyColor, t)!,
      biohazardColor: Color.lerp(biohazardColor, other.biohazardColor, t)!,
      dnaColor: Color.lerp(dnaColor, other.dnaColor, t)!,
      glowEffect: Color.lerp(glowEffect, other.glowEffect, t)!,
    );
  }
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.primaryAccentColor,
      surface: Colors.white,
      background: Colors.white,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: AppColors.textColorPrimary,
      onBackground: AppColors.textColorPrimary,
    ),
    textTheme: TextTheme(
      displayLarge: AppStyles.titleLarge.copyWith(color: AppColors.primaryColor),
      displayMedium: AppStyles.titleMedium.copyWith(color: AppColors.textColorPrimary),
      displaySmall: AppStyles.titleSmall.copyWith(color: AppColors.textColorPrimary),
      bodyLarge: AppStyles.bodyLarge.copyWith(color: AppColors.textColorPrimary),
      bodyMedium: AppStyles.bodyMedium.copyWith(color: AppColors.textColorPrimary),
      bodySmall: AppStyles.bodySmall.copyWith(color: AppColors.textColorSecondary),
      titleLarge: AppStyles.accentLarge.copyWith(color: AppColors.primaryAccentColor),
      titleMedium: AppStyles.accentMedium.copyWith(color: AppColors.primaryAccentColor),
      titleSmall: AppStyles.accentSmall.copyWith(color: AppColors.primaryAccentColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.black,
        textStyle: AppStyles.buttonText,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2.0,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.primaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: AppAssets.titleFont,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      ),
      iconTheme: IconThemeData(color: AppColors.primaryColor),
      actionsIconTheme: IconThemeData(color: AppColors.primaryColor),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 1.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: AppColors.borderColor.withOpacity(0.5),
          width: 0.5,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      labelStyle: AppStyles.bodyMedium.copyWith(color: AppColors.textColorSecondary),
      hintStyle: AppStyles.bodyMedium.copyWith(color: AppColors.textColorSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColors.borderColor.withOpacity(0.7)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColors.borderColor.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: AppColors.errorColor),
      ),
      focusedErrorBorder:  OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColors.errorColor, width: 2.0),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.borderColor.withOpacity(0.3),
      thickness: 0.5,
      space: 16.0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.black,
      elevation: 2.0,
      highlightElevation: 4.0,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[200],
      disabledColor: Colors.grey[300],
      selectedColor: AppColors.primaryColor,
      secondarySelectedColor: AppColors.primaryAccentColor,
      padding: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: AppColors.borderColor.withOpacity(0.5)),
      ),
      labelStyle: AppStyles.bodySmall.copyWith(color: AppColors.textColorPrimary),
      secondaryLabelStyle: AppStyles.bodySmall.copyWith(color: Colors.black),
      brightness: Brightness.light,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(4.0),
      ),
      textStyle: AppStyles.bodySmall.copyWith(color: Colors.white),
    ),
    extensions: <ThemeExtension<dynamic>>[
      _ImmunoWarriorsTheme(
        pathogenColor: AppColors.pathogenColor,
        antibodyColor: AppColors.antibodyColor,
        biohazardColor: AppColors.biohazardColor,
        dnaColor: AppColors.dnaColor,
        glowEffect: AppColors.glowEffect,
      ),
    ],
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.primaryAccentColor,
      surface: AppColors.secondaryColor,
      background: AppColors.backgroundColor,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: AppColors.textColorPrimary,
      onBackground: AppColors.textColorPrimary,
    ),
    textTheme: TextTheme(
      displayLarge: AppStyles.titleLarge.copyWith(color: AppColors.primaryColor),
      displayMedium: AppStyles.titleMedium.copyWith(color: AppColors.textColorPrimary),
      displaySmall: AppStyles.titleSmall.copyWith(color: AppColors.textColorPrimary),
      bodyLarge: AppStyles.bodyLarge.copyWith(color: AppColors.textColorPrimary),
      bodyMedium: AppStyles.bodyMedium.copyWith(color: AppColors.textColorPrimary),
      bodySmall: AppStyles.bodySmall.copyWith(color: AppColors.textColorSecondary),
      titleLarge: AppStyles.accentLarge.copyWith(color: AppColors.primaryAccentColor),
      titleMedium: AppStyles.accentMedium.copyWith(color: AppColors.primaryAccentColor),
      titleSmall: AppStyles.accentSmall.copyWith(color: AppColors.primaryAccentColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.black,
        textStyle: AppStyles.buttonText,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4.0,
        shadowColor: AppColors.glowEffect,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.primaryColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.secondaryColor,
      elevation: 0,
      titleTextStyle: AppStyles.titleMedium.copyWith(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: AppColors.primaryColor),
      actionsIconTheme: const IconThemeData(color: AppColors.primaryColor),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.secondaryColor,
      elevation: 2.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      shadowColor: AppColors.glowEffect,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.secondaryColor,
      titleTextStyle: AppStyles.titleMedium.copyWith(color: AppColors.primaryColor),
      contentTextStyle: AppStyles.bodyMedium.copyWith(color: AppColors.textColorPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: AppColors.primaryColor.withOpacity(0.5),
          width: 1.0,
        ),
      ),
      elevation: 8.0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.secondaryColor.withOpacity(0.7),
      labelStyle: AppStyles.bodyMedium.copyWith(color: AppColors.textColorSecondary),
      hintStyle: AppStyles.bodyMedium.copyWith(color: AppColors.textColorSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColors.borderColor.withOpacity(0.7)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColors.borderColor.withOpacity(0.5)),
      ),
      focusedBorder:  OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColors.errorColor),
      ),
      focusedErrorBorder:  OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColors.errorColor, width: 2.0),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.borderColor.withOpacity(0.5),
      thickness: 0.5,
      space: 16.0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.black,
      elevation: 4.0,
      highlightElevation: 8.0,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.secondaryColor,
      disabledColor: AppColors.secondaryColor.withOpacity(0.5),
      selectedColor: AppColors.primaryColor,
      secondarySelectedColor: AppColors.primaryAccentColor,
      padding: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: AppColors.borderColor.withOpacity(0.5)),
      ),
      labelStyle: AppStyles.bodySmall.copyWith(color: AppColors.textColorPrimary),
      secondaryLabelStyle: AppStyles.bodySmall.copyWith(color: Colors.black),
      brightness: Brightness.dark,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      textStyle: AppStyles.bodySmall.copyWith(color: AppColors.primaryColor),
    ),
    extensions: <ThemeExtension<dynamic>>[
      _ImmunoWarriorsTheme(
        pathogenColor: AppColors.pathogenColor,
        antibodyColor: AppColors.antibodyColor,
        biohazardColor: AppColors.biohazardColor,
        dnaColor: AppColors.dnaColor,
        glowEffect: AppColors.glowEffect,
      ),
    ],
  );
}