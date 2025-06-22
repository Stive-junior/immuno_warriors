import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immuno_warriors/core/routes/app_router.dart';
import 'package:immuno_warriors/shared/ui/app_colors.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Immuno Warriors',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textColorPrimary),
        ),
        iconTheme: IconThemeData(
          color:
              AppColors.textColorPrimary, // Couleur explicite pour les icônes
          size: 24,
          // Taille par défaut
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        iconTheme: IconThemeData(color: AppColors.textColorPrimary, size: 24),
      ),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child,
        );
      },
    );
  }
}
