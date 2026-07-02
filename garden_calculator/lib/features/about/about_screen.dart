import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/page_container.dart';
import '../../widgets/section_header.dart';

/// Project overview, feature list and tech credits.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _features = [
    ('Crop value calculator', 'Weight, mutations, quantity & friend boost.',
        Icons.calculate_rounded),
    ('Mutation stacker', 'Combine any mutations and project onto a base value.',
        Icons.auto_awesome_rounded),
    ('Crop database', 'Search, filter and sort every crop by rarity.',
        Icons.grid_view_rounded),
    ('Pet estimator', 'Estimate pet worth from species, age and weight.',
        Icons.pets_rounded),
    ('Dark & light themes', 'A remembered, system-agnostic theme toggle.',
        Icons.dark_mode_rounded),
    ('Fully responsive', 'Tuned for desktop, tablet and mobile.',
        Icons.devices_rounded),
  ];

  static const _stack = [
    ('Flutter Web', '🎯'),
    ('Riverpod', '🧩'),
    ('GoRouter', '🧭'),
    ('Clean Architecture', '🏛️'),
    ('Material 3', '🎨'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'About',
            title: 'About GrowVault',
            subtitle:
                'A premium, original calculator suite for the Grow a Garden '
                'community.',
            icon: Icons.info_outline_rounded,
          ),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: AppColors.brandGradient,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                          child: Text('🌱',
                              style: TextStyle(fontSize: 30))),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppConstants.appName,
                            style: theme.textTheme.headlineMedium),
                        Text('v${AppConstants.appVersion}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'GrowVault reimagines the classic Grow a Garden calculator '
                  'as a modern dashboard. Every feature — value calculation, '
                  'mutation stacking, the crop database and pet estimation — '
                  'is rebuilt from scratch with an original design language, '
                  'a fresh emerald palette and smooth, accessible interactions. '
                  'No third-party branding, artwork or assets are used.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.75)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Features', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, c) {
            final columns = c.maxWidth > 900 ? 3 : (c.maxWidth > 560 ? 2 : 1);
            const gap = 16.0;
            final w = (c.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final f in _features)
                  SizedBox(
                    width: w,
                    child: GlassCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(f.$3, color: theme.colorScheme.primary),
                          const SizedBox(height: 12),
                          Text(f.$1, style: theme.textTheme.titleMedium),
                          const SizedBox(height: 6),
                          Text(f.$2,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  height: 1.45,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.65))),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Built with', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final s in _stack)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: theme.colorScheme.outline),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.$2,
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text(s.$1,
                                style: theme.textTheme.titleSmall),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Text(
              'Disclaimer: GrowVault is an unofficial fan-made tool and is not '
              'affiliated with, endorsed by, or connected to the creators of '
              'Grow a Garden or Roblox Corporation. All values are estimates.',
              style: theme.textTheme.bodySmall?.copyWith(
                  height: 1.5,
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton.icon(
              onPressed: () => context.go(Routes.home),
              icon: const Icon(Icons.home_rounded),
              label: const Text('Back to dashboard'),
            ),
          ),
        ],
      ),
    );
  }
}
