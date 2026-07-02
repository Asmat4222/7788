import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/about/about_screen.dart';
import '../../features/calculator/calculator_screen.dart';
import '../../features/database/crop_database_screen.dart';
import '../../features/guide/guide_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/mutation/mutation_calculator_screen.dart';
import '../../features/pet/pet_calculator_screen.dart';
import '../../widgets/app_shell.dart';
import '../constants/app_constants.dart';

/// Central GoRouter configuration. A [ShellRoute] keeps the persistent
/// navigation frame mounted while the child page swaps with a fade.
final GoRouter appRouter = GoRouter(
  initialLocation: Routes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          AppShell(location: state.uri.path, child: child),
      routes: [
        _page(Routes.home, const HomeScreen()),
        _page(Routes.calculator, const CalculatorScreen()),
        _page(Routes.mutations, const MutationCalculatorScreen()),
        _page(Routes.database, const CropDatabaseScreen()),
        _page(Routes.pet, const PetCalculatorScreen()),
        _page(Routes.guide, const GuideScreen()),
        _page(Routes.about, const AboutScreen()),
      ],
    ),
  ],
  errorBuilder: (context, state) => const _NotFound(),
);

GoRoute _page(String path, Widget child) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 320),
      transitionsBuilder: (context, animation, secondary, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.02),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    ),
  );
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌫️', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 12),
            Text('Page not found',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => context.go(Routes.home),
              child: const Text('Back to dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
