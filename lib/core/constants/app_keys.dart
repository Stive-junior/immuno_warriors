// core/constants/app_keys.dart

import 'package:flutter/material.dart';

class AppKeys {

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Clés pour les boutons d'authentification
  static const String loginButtonKey = 'login_button';
  static const String registerButtonKey = 'register_button';
  static const String forgotPasswordButtonKey = 'forgot_password_button';

  // Clés pour les champs de texte
  static const String emailTextFieldKey = 'email_text_field';
  static const String passwordTextFieldKey = 'password_text_field';

  // Clés pour les éléments de l'interface utilisateur (pour les tests)
  static const String combatScreenKey = 'combat_screen';
  static const String researchScreenKey = 'research_screen';
  static const String bioForgeScreenKey = 'bio_forge_screen';
  static const String dashboardScreenKey = 'dashboard_screen';
  static const String warArchiveScreenKey = 'war_archive_screen';
  static const String threatScannerScreenKey = 'threat_scanner_screen';

  // Clés pour les dialogues et alertes
  static const String confirmationDialogKey = 'confirmation_dialog';
  static const String errorDialogKey = 'error_dialog';
  static const String infoSnackBarKey = 'info_snack_bar';

  // Clés pour les animations
  static const String loadingAnimationKey = 'loading_animation';
  static const String combatEffectAnimationKey = 'combat_effect_animation';

  // Clés pour les widgets de liste
  static const String pathogenListKey = 'pathogen_list';
  static const String antibodyListKey = 'antibody_list';
  static const String researchNodeListKey = 'research_node_list';

  // Clés pour les formulaires
  static const String bioForgeFormKey = 'bio_forge_form';

  // Clés pour les éléments interactifs
  static const String baseConfigGridKey = 'base_config_grid';

  // Clés pour les graphiques
  static const String resourceGaugeKey = 'resource_gauge';

  // Clés pour les éléments de l'archive de guerre
  static const String combatReportListKey = 'combat_report_list';
}