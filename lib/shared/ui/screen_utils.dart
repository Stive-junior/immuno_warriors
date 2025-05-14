import 'package:flutter/material.dart';

class ScreenUtils {

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Orientation getScreenOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  // Calculer une taille relative en fonction de la largeur de l'écran
  static double getRelativeWidth(BuildContext context, double percentage) {
    return getScreenWidth(context) * (percentage / 100);
  }


  static double getRelativeHeight(BuildContext context, double percentage) {
    return getScreenHeight(context) * (percentage / 100);
  }


  static bool isSmallScreen(BuildContext context) {
    return getScreenWidth(context) < 600; // Valeur arbitraire, à ajuster selon les besoins
  }

  // Vérifier si l'écran est grand (par exemple, une tablette)
  static bool isLargeScreen(BuildContext context) {
    return getScreenWidth(context) > 900; // Valeur arbitraire, à ajuster selon les besoins
  }


}