import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/responsive.dart';
import '../../data/datasources/crop_data.dart';
import '../../data/datasources/mutation_data.dart';
import '../../data/models/rarity.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/page_container.dart';
import '../../widgets/rarity_badge.dart';

/// The landing dashboard: hero, quick-launch tool cards and highlights.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Hero(),
          SizedBox(height: 34),
          _ToolGrid(),
          SizedBox(height: 34),
          _StatsStrip(),
          SizedBox(height: 34),
          _TopCrops(),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);

    return GlassCard(
      padding: EdgeInsets.all(isMobile ? 24 : 44),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.emerald.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                        color: AppColors.emerald.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded,
                          size: 15, color: AppColors.emeraldLight),
                      const SizedBox(width: 6),
                      Text('Real-time value engine',
                          style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.emeraldLight,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Master every crop\'s true value.',
                  style: (isMobile
                          ? theme.textTheme.displayMedium
                          : theme.textTheme.displayLarge)
                      ?.copyWith(height: 1.05),
                ),
                const SizedBox(height: 16),
                Text(
                  'GrowVault is a premium calculator suite for Grow a Garden. '
                  'Compute exact crop values, stack mutation multipliers, '
                  'browse the full crop database and estimate pet worth — all '
                  'in one modern dashboard.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.72),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 26),
                Wrap(
                  spacing: 14,
                  runSpacing: 12,
                  children: [
                    GradientButton(
                      label: 'Open Crop Calculator',
                      icon: Icons.calculate_rounded,
                      onPressed: () => context.go(Routes.calculator),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.go(Routes.mutations),
                      icon: const Icon(Icons.auto_awesome_rounded),
                      label: const Text('Stack Mutations'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!isMobile) const SizedBox(width: 30),
          if (!isMobile) const Expanded(flex: 2, child: _HeroPreview()),
        ],
      ),
    );
  }
}

class _HeroPreview extends StatelessWidget {
  const _HeroPreview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.emerald.withValues(alpha: 0.18),
            AppColors.violet.withValues(alpha: 0.14),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🐲', style: TextStyle(fontSize: 30)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dragon Fruit',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 3),
                  const RarityBadge(
                      rarity: Rarity.legendary, compact: true),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          _previewRow(theme, 'Weight', '14.20 kg'),
          _previewRow(theme, 'Mutations', 'Rainbow · Shocked'),
          _previewRow(theme, 'Multiplier', '5,000×'),
          const Divider(height: 26),
          Text('ESTIMATED VALUE',
              style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.2,
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 4),
          Text(
            '${Formatters.compact(33000000)} 🪙',
            style: theme.textTheme.displaySmall?.copyWith(
              color: AppColors.goldLight,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewRow(ThemeData theme, String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k,
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.6))),
          Text(v,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _ToolGrid extends StatelessWidget {
  const _ToolGrid();

  static const _tools = [
    _Tool('Crop Value Calculator', 'Weight, mutations, quantity & friend boost.',
        Icons.calculate_rounded, Routes.calculator, AppColors.emerald),
    _Tool('Mutation Stacker', 'See combined multipliers for any stack.',
        Icons.auto_awesome_rounded, Routes.mutations, AppColors.violet),
    _Tool('Crop Database', 'Browse every crop, value and rarity.',
        Icons.grid_view_rounded, Routes.database, AppColors.sky),
    _Tool('Pet Value Estimator', 'Estimate pet worth by age & weight.',
        Icons.pets_rounded, Routes.pet, AppColors.gold),
  ];

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.gridColumns(context,
        mobile: 1, tablet: 2, desktop: 4);
    return LayoutBuilder(builder: (context, constraints) {
      const gap = 18.0;
      final itemWidth =
          (constraints.maxWidth - gap * (columns - 1)) / columns;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final t in _tools)
            SizedBox(width: itemWidth, child: _ToolCard(tool: t)),
        ],
      );
    });
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({required this.tool});
  final _Tool tool;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      hoverLift: true,
      onTap: () => context.go(tool.route),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: tool.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(tool.icon, color: tool.color, size: 26),
          ),
          const SizedBox(height: 18),
          Text(tool.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            tool.subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Open',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(color: tool.color)),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_rounded,
                  size: 16, color: tool.color),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip();

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('${CropData.all.length}', 'Crops catalogued'),
      ('${MutationData.all.length}', 'Mutations mapped'),
      ('8', 'Rarity tiers'),
      ('∞', 'Stack combinations'),
    ];
    final columns =
        Responsive.gridColumns(context, mobile: 2, tablet: 4, desktop: 4);
    return LayoutBuilder(builder: (context, c) {
      const gap = 16.0;
      final w = (c.maxWidth - gap * (columns - 1)) / columns;
      final theme = Theme.of(context);
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final s in stats)
            SizedBox(
              width: w,
              child: GlassCard(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.$1,
                        style: theme.textTheme.displaySmall?.copyWith(
                            color: AppColors.emeraldLight,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(s.$2,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6))),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }
}

class _TopCrops extends StatelessWidget {
  const _TopCrops();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final top = [...CropData.all]
      ..sort((a, b) => b.baseValue.compareTo(a.baseValue));
    final featured = top.take(6).toList();
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Highest base-value crops',
                    style: theme.textTheme.headlineSmall),
              ),
              TextButton.icon(
                onPressed: () => context.go(Routes.database),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final crop in featured)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Text(crop.emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(crop.name,
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 2),
                        RarityBadge(rarity: crop.rarity, compact: true),
                      ],
                    ),
                  ),
                  Text('${Formatters.sheckles(crop.baseValue)} 🪙',
                      style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.goldLight,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Tool {
  const _Tool(
      this.title, this.subtitle, this.icon, this.route, this.color);
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color color;
}
