/// Keys for widgets and testing in Immuno Warriors.
///
/// This file organizes keys for UI elements, screens, and tests.
import 'package:flutter/material.dart';

class AppKeys {
  /// --- Navigation ---
  /// Global navigator key for app navigation.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// --- Authentication ---
  /// Key for the login button.
  static const String loginButtonKey = 'login_button';

  /// Key for the register button.
  static const String registerButtonKey = 'register_button';

  /// Key for the forgot password button.
  static const String forgotPasswordButtonKey = 'forgot_password_button';

  /// Key for the email text field.
  static const String emailTextFieldKey = 'email_text_field';

  /// Key for the password text field.
  static const String passwordTextFieldKey = 'password_text_field';

  /// --- Screens ---
  /// Key for the combat screen.
  static const String combatScreenKey = 'combat_screen';

  /// Key for the research screen.
  static const String researchScreenKey = 'research_screen';

  /// Key for the BioForge screen.
  static const String bioForgeScreenKey = 'bio_forge_screen';

  /// Key for the dashboard screen.
  static const String dashboardScreenKey = 'dashboard_screen';

  /// Key for the war archive screen.
  static const String warArchiveScreenKey = 'war_archive_screen';

  /// Key for the threat scanner screen.
  static const String threatScannerScreenKey = 'threat_scanner_screen';

  /// --- Dialogs and Alerts ---
  /// Key for confirmation dialogs.
  static const String confirmationDialogKey = 'confirmation_dialog';

  /// Key for error dialogs.
  static const String errorDialogKey = 'error_dialog';

  /// Key for info snack bars.
  static const String infoSnackBarKey = 'info_snack_bar';

  /// --- Animations ---
  /// Key for loading animations.
  static const String loadingAnimationKey = 'loading_animation';

  /// Key for combat effect animations.
  static const String combatEffectAnimationKey = 'combat_effect_animation';

  /// --- Lists ---
  /// Key for the pathogen list.
  static const String pathogenListKey = 'pathogen_list';

  /// Key for the antibody list.
  static const String antibodyListKey = 'antibody_list';

  /// Key for the research node list.
  static const String researchNodeListKey = 'research_node_list';

  /// --- Forms ---
  /// Key for the BioForge form.
  static const String bioForgeFormKey = 'bio_forge_form';

  /// --- Interactive Elements ---
  /// Key for the base configuration grid.
  static const String baseConfigGridKey = 'base_config_grid';

  /// --- Charts ---
  /// Key for the resource gauge.
  static const String resourceGaugeKey = 'resource_gauge';

  /// --- War Archive ---
  /// Key for the combat report list.
  static const String combatReportListKey = 'combat_report_list';
}
