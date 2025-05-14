import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/combat/presentation/screens/combat_screen.dart';
import '../../features/research/presentation/screens/research_screen.dart';
import '../../features/bio_forge/presentation/screens/bio_forge_screen.dart';
import '../../features/war_archive/presentation/screens/archive_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/threat_scanner/presentation/screens/threat_scanner_screen.dart';
import 'route_names.dart';
import 'route_transitions.dart';

/// Manages the app's routing.
class AppRouter {
  /// Generates routes for the app.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return FadeRoute(page: const LoginScreen());
      case RouteNames.register:
        return FadeRoute(page: const RegisterScreen());
      case RouteNames.dashboard:
        return SlideLeftRoute(page: const DashboardScreen());
      case RouteNames.combat:
        return SlideLeftRoute(page: const CombatScreen());
      case RouteNames.research:
        return SlideLeftRoute(page: const ResearchScreen());
      case RouteNames.bioForge:
        return SlideLeftRoute(page: const BioForgeScreen());
      case RouteNames.warArchive:
        return SlideLeftRoute(page: const ArchiveScreen());
      case RouteNames.threatScanner:
        return SlideLeftRoute(page: const ThreatScannerScreen());
      default:
        return _errorRoute();
    }
  }

  /// Returns an error route for unknown route names.
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('ERROR: Route not found')),
      ),
    );
  }
}