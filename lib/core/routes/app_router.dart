// Manages routing for Immuno Warriors using GoRouter with custom transitions
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:immuno_warriors/core/constants/app_animations.dart';
import 'package:immuno_warriors/core/utils/app_logger.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/profile_auth_options_screen.dart';
import '../../features/auth/screens/profile_auth_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/bio_forge/screens/bio_forge_screen.dart';
import '../../features/combat/screens/combat_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/gemini/presentation/screens/gemini_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/research/presentation/screens/research_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/threat_scanner/screens/threat_scanner_screen.dart';
import '../../features/war_archive/presentation/screens/archive_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/help/screens/help_screen.dart';
import '../../features/leaderboard/screens/leaderboard_screen.dart';
import '../../features/multiplayer/screens/multiplayer_screen.dart';
import 'route_names.dart';
import 'route_transitions.dart';

/// Provides the app's router.
final appRouterProvider = Provider<GoRouter>((ref) {
  AppLogger.info("goooooooooooooooooooooooooooooo");
  final router = GoRouter(
    initialLocation: '/${RouteNames.splash}',
    redirect: (context, state) async {
      final user = FirebaseAuth.instance.currentUser;
      final isAuthenticated = user != null;
      final isOnAuthRoute =
          state.matchedLocation.startsWith(
            '/${RouteNames.profileAuthOptions}',
          ) ||
          state.matchedLocation.startsWith('/${RouteNames.login}') ||
          state.matchedLocation.startsWith('/${RouteNames.register}') ||
          state.matchedLocation.startsWith('/${RouteNames.profileAuth}');
      final isOnSplash = state.matchedLocation == '/${RouteNames.splash}';

      if (isOnSplash) return null; // Allow splash to handle its own redirect

      if (!isAuthenticated && !isOnAuthRoute) {
        return '/${RouteNames.home}';
      } else if (isAuthenticated && isOnAuthRoute) {
        return '/${RouteNames.dashboard}';
      }
      return null;
    },
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      /// --- Splash Route ---
      GoRoute(
        path: '/${RouteNames.splash}',
        name: RouteNames.splash,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const SplashScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeRoute(page: child).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
              transitionDuration: AppAnimations.durationLong,
            ),
      ),

      /// --- Home Route ---
      GoRoute(
        path: '/${RouteNames.home}',
        name: RouteNames.home,
        pageBuilder:
            (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: const HomeScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeRoute(page: child).buildTransitions(
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ),
              transitionDuration: AppAnimations.durationNormal,
            ),
        routes: [
          /// Authentication Options
          GoRoute(
            path: RouteNames.profileAuthOptions,
            name: RouteNames.profileAuthOptions,
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const ProfileAuthOptionsScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          SlideRightRoute(page: child).buildTransitions(
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ),
                  transitionDuration: AppAnimations.durationNormal,
                ),
            routes: [
              GoRoute(
                path: RouteNames.login,
                name: RouteNames.login,
                pageBuilder:
                    (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const LoginScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeSlideRightRoute(page: child).buildTransitions(
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ),
                      transitionDuration: AppAnimations.durationNormal,
                    ),
              ),
              GoRoute(
                path: RouteNames.register,
                name: RouteNames.register,
                pageBuilder:
                    (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const RegisterScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeSlideRightRoute(page: child).buildTransitions(
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ),
                      transitionDuration: AppAnimations.durationNormal,
                    ),
              ),
              GoRoute(
                path: RouteNames.loginFromRegister,
                name: RouteNames.loginFromRegister,
                pageBuilder:
                    (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const LoginScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeRoute(page: child).buildTransitions(
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ),
                      transitionDuration: AppAnimations.durationNormal,
                    ),
              ),
              GoRoute(
                path: RouteNames.registerFromLogin,
                name: RouteNames.registerFromLogin,
                pageBuilder:
                    (context, state) => CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const RegisterScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeRoute(page: child).buildTransitions(
                                context,
                                animation,
                                secondaryAnimation,
                                child,
                              ),
                      transitionDuration: AppAnimations.durationNormal,
                    ),
              ),
            ],
          ),

          /// Profile Authentication
          GoRoute(
            path: '${RouteNames.profileAuth}/:userId',
            name: RouteNames.profileAuth,
            pageBuilder: (context, state) {
              final userId = state.pathParameters['userId']!;
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: ProfileAuthScreen(userId: userId),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        SlideUpRoute(page: child).buildTransitions(
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ),
                transitionDuration: AppAnimations.durationNormal,
              );
            },
          ),
        ],
      ),

      ShellRoute(
        builder: (context, state, child) => ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/${RouteNames.dashboard}',
            name: RouteNames.dashboard,
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const DashboardScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          SlideLeftRoute(page: child).buildTransitions(
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ),
                  transitionDuration: AppAnimations.durationNormal,
                ),
          ),
          GoRoute(
            path: '/${RouteNames.combat}',
            name: RouteNames.combat,
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const CombatScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          SlideLeftRoute(page: child).buildTransitions(
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ),
                  transitionDuration: AppAnimations.durationNormal,
                ),
          ),
          GoRoute(
            path: '/${RouteNames.bioForge}',
            name: RouteNames.bioForge,
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const BioForgeScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          SlideLeftRoute(page: child).buildTransitions(
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ),
                  transitionDuration: AppAnimations.durationNormal,
                ),
          ),
          GoRoute(
            path: '/${RouteNames.threatScanner}',
            name: RouteNames.threatScanner,
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const ThreatScannerScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          SlideLeftRoute(page: child).buildTransitions(
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ),
                  transitionDuration: AppAnimations.durationNormal,
                ),
          ),
          GoRoute(
            path: '/${RouteNames.gemini}',
            name: RouteNames.gemini,
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const GeminiScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeRoute(page: child).buildTransitions(
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ),
                  transitionDuration: AppAnimations.durationNormal,
                ),
          ),
          GoRoute(
            path: '/${RouteNames.research}',
            name: RouteNames.research,
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const ResearchScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          SlideLeftRoute(page: child).buildTransitions(
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ),
                  transitionDuration: AppAnimations.durationNormal,
                ),
            routes: [
              GoRoute(
                path: '${RouteNames.researchNode}/:nodeId',
                name: RouteNames.researchNode,
                pageBuilder: (context, state) {
                  final nodeId = state.pathParameters['nodeId']!;
                  return CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: ResearchScreen(nodeId: nodeId),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            FadeSlideRightRoute(page: child).buildTransitions(
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ),
                    transitionDuration: AppAnimations.durationNormal,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/${RouteNames.warArchive}',
            name: RouteNames.warArchive,
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const ArchiveScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          SlideLeftRoute(page: child).buildTransitions(
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ),
                  transitionDuration: AppAnimations.durationNormal,
                ),
          ),
          GoRoute(
            path: '/${RouteNames.settings}',
            name: RouteNames.settings,
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const SettingsScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          SlideRightRoute(page: child).buildTransitions(
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ),
                  transitionDuration: AppAnimations.durationNormal,
                ),
          ),
          GoRoute(
            path: '/${RouteNames.help}',
            name: RouteNames.help,
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const HelpScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          SlideUpRoute(page: child).buildTransitions(
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ),
                  transitionDuration: AppAnimations.durationNormal,
                ),
          ),
          GoRoute(
            path: '/${RouteNames.leaderboard}',
            name: RouteNames.leaderboard,
            pageBuilder:
                (context, state) => CustomTransitionPage<void>(
                  key: state.pageKey,
                  child: const LeaderboardScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeRoute(page: child).buildTransitions(
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ),
                  transitionDuration: AppAnimations.durationNormal,
                ),
          ),
          GoRoute(
            path: '/${RouteNames.multiplayer}/:gameId',
            name: RouteNames.multiplayer,
            pageBuilder: (context, state) {
              final gameId = state.pathParameters['gameId']!;
              return CustomTransitionPage<void>(
                key: state.pageKey,
                child: MultiplayerScreen(gameId: gameId),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeSlideRightRoute(page: child).buildTransitions(
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ),
                transitionDuration: AppAnimations.durationNormal,
              );
            },
          ),
        ],
      ),

      /// --- Catch-All Route ---
      GoRoute(
        path: '/:anything(.*)',
        builder: (context, state) => const NotFoundScreen(),
      ),
    ],
  );

  return router;
});

/// Shell scaffold for main feature screens with bottom navigation.
class ShellScaffold extends StatelessWidget {
  final Widget child;

  const ShellScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: child),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: AppStrings.dashboardTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_kabaddi),
            label: AppStrings.combatTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.biotech),
            label: AppStrings.bioForgeTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: AppStrings.threatScannerTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: AppStrings.geminiTitle,
          ),
        ],
        currentIndex: _getCurrentIndex(context),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.cardBackground,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/${RouteNames.dashboard}')) return 0;
    if (location.startsWith('/${RouteNames.combat}')) return 1;
    if (location.startsWith('/${RouteNames.bioForge}')) return 2;
    if (location.startsWith('/${RouteNames.threatScanner}')) return 3;
    if (location.startsWith('/${RouteNames.gemini}')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(RouteNames.dashboard);
        break;
      case 1:
        context.goNamed(RouteNames.combat);
        break;
      case 2:
        context.goNamed(RouteNames.bioForge);
        break;
      case 3:
        context.goNamed(RouteNames.threatScanner);
        break;
      case 4:
        context.goNamed(RouteNames.gemini);
        break;
    }
  }
}

/// Screen for unmatched routes.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 64),
            const SizedBox(height: 16),
            Text(
              AppStrings.errorTitle,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.errorMessage,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.buttonTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () => context.goNamed(RouteNames.home),
              child: Text(
                AppStrings.back,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
