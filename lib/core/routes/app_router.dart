import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immuno_warriors/core/routes/route_names.dart';
import 'package:immuno_warriors/core/routes/route_transitions.dart';
import 'package:immuno_warriors/features/auth/presentation/screens/login_screen.dart';
import 'package:immuno_warriors/features/auth/presentation/screens/profile_auth_options_screen.dart';
import 'package:immuno_warriors/features/auth/presentation/screens/profile_auth_screen.dart';
import 'package:immuno_warriors/features/auth/presentation/screens/register_screen.dart';
import 'package:immuno_warriors/features/bio_forge/presentation/screens/bio_forge_screen.dart';
import 'package:immuno_warriors/features/combat/presentation/screens/combat_screen.dart';
import 'package:immuno_warriors/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:immuno_warriors/features/gemini/presentation/screens/gemini_screen.dart';
import 'package:immuno_warriors/features/home/home_screen.dart';

import 'package:immuno_warriors/features/splash/splash_screen.dart';
import 'package:immuno_warriors/features/threat_scanner/presentation/screens/threat_scanner_screen.dart';

/// Manages the app's routing using GoRouter with custom transitions.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const SplashScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeRoute(page: const SplashScreen()).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Add duration if needed
            ),
      ),
      GoRoute(
        path: '/home',
        name: RouteNames.home,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const HomeScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeRoute(page: const HomeScreen()).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Add duration if needed
            ),
      ),
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const LoginScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeRoute(page: const LoginScreen()).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
              transitionDuration: const Duration(
                milliseconds: 300,
              ), // Add duration if needed
            ),
        routes: [
          GoRoute(
            path: '/profileAuthOptions', // /login/new
            name: RouteNames.profileAuthOptions,
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const ProfileAuthOptionsScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeRoute(page: const ProfileAuthOptionsScreen()).buildTransitions(
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ),
                  transitionDuration: const Duration(
                    milliseconds: 300,
                  ), // Add duration if needed
                ),
          ),
        ],
      ),
      GoRoute(
        path: '/register',
        name: RouteNames.register,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const RegisterScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeRoute(page: const RegisterScreen()).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
              transitionDuration: const Duration(milliseconds: 300),
            ),
        routes: [
          GoRoute(
            path: 'existing', // /register/existing
            name: RouteNames.loginFromRegister,
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const LoginScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeRoute(page: const LoginScreen()).buildTransitions(
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ),
                  transitionDuration: const Duration(
                    milliseconds: 300,
                  ), // Add duration if needed
                ),
          ),
        ],
      ),
     /* GoRoute(
        path: '/dashboard',
        name: RouteNames.dashboard,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const DashboardScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideLeftRoute(
                        page: const DashboardScreen(),
                      ).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
            ),
      ),
      GoRoute(
        path: '/combat',
        name: RouteNames.combat,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const CombatScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideLeftRoute(
                        page: const CombatScreen(),
                      ).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
            ),
      ),
      GoRoute(
        path: '/research',
        name: RouteNames.research,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const ResearchScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideLeftRoute(
                        page: const ResearchScreen(),
                      ).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
            ),
      ),
      GoRoute(
        path: '/bioForge',
        name: RouteNames.bioForge,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const BioForgeScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideLeftRoute(
                        page: const BioForgeScreen(),
                      ).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
            ),
      ),
      GoRoute(
        path: '/warArchive',
        name: RouteNames.warArchive,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const ArchiveScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideLeftRoute(
                        page: const ArchiveScreen(),
                      ).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
            ),
      ),
      GoRoute(
        path: '/threatScanner',
        name: RouteNames.threatScanner,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const ThreatScannerScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideLeftRoute(
                        page: const ThreatScannerScreen(),
                      ).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
            ),
      ),
      GoRoute(
        path: '/profileAuth/:userId',
        name: RouteNames.profileAuth,
        pageBuilder: (context, state) {
          final String? userId = state.pathParameters['userId'];
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: ProfileAuthScreen(userId: userId),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => FadeRoute(
                  page: ProfileAuthScreen(userId: userId),
                ).buildTransitions(
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ),
          );
        },
      ),
      GoRoute(
        path: '/profileAuthOptions',
        name: RouteNames.profileAuthOptions,
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: ProfileAuthOptionsScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => FadeRoute(
                  page: ProfileAuthOptionsScreen(),
                ).buildTransitions(
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ),
          );
        },
      ),
      GoRoute(
        path: '/settings',
        name: RouteNames.settings,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const SettingsScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideRightRoute(
                        page: const SettingsScreen(),
                      ).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
            ),
      ),
      GoRoute(
        path: '/help',
        name: RouteNames.help,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const HelpScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideUpRoute(page: const HelpScreen()).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
            ),
      ),
      GoRoute(
        path: '/gemini',
        name: RouteNames.gemini,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const GeminiScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeRoute(page: const GeminiScreen()).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
            ),
      ),*/
    ],
  );
});
