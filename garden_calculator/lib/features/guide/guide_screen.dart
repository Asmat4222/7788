import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/datasources/mutation_data.dart';
import '../../data/models/rarity.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/page_container.dart';
import '../../widgets/section_header.dart';

/// Explains the value formula, mutation rules and includes an FAQ.
class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Learn',
            title: 'How the calculator works',
            subtitle:
                'The exact maths behind crop value, and the rules that govern '
                'mutation stacking.',
            icon: Icons.menu_book_rounded,
          ),
          const SizedBox(height: 24),
          const _FormulaCard(),
          const SizedBox(height: 20),
          const _StepsCard(),
          const SizedBox(height: 20),
          const _MutationRulesCard(),
          const SizedBox(height: 20),
          const _FaqCard(),
          const SizedBox(height: 24),
          _CtaCard(),
        ],
      ),
    );
  }
}

class _FormulaCard extends StatelessWidget {
  const _FormulaCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('The value formula', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.emerald.withValues(alpha: 0.16),
                  AppColors.violet.withValues(alpha: 0.12),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _formulaLine(theme, 'Value ='),
                _formulaLine(theme,
                    '  Base Value × (Weight ÷ Base Weight)²',
                    accent: AppColors.sky),
                _formulaLine(theme, '  × Growth Multiplier',
                    accent: AppColors.violet),
                _formulaLine(theme,
                    '  × (1 + Σ Environmental − Env Count)',
                    accent: AppColors.gold),
                _formulaLine(theme, '  × (1 + Friend Boost ÷ 100)',
                    accent: AppColors.emeraldLight),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Weight has the biggest single influence because it is squared — '
            'a crop at twice its base weight is worth roughly four times as '
            'much before any mutations apply.',
            style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.72)),
          ),
        ],
      ),
    );
  }

  Widget _formulaLine(ThemeData theme, String text, {Color? accent}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 15,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: accent ?? theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _StepsCard extends StatelessWidget {
  const _StepsCard();

  static const _steps = [
    (
      'Weight factor',
      'Divide the crop\'s weight by its base weight, then square the result. '
          'This is the crop-value step.'
    ),
    (
      'Mutation value',
      'Multiply the growth mutation (Gold ×20 or Rainbow ×50) by the '
          'environmental term: 1 + the sum of every environmental multiplier, '
          'minus the number of environmental mutations.'
    ),
    (
      'Final value',
      'Multiply the base price by the weight factor and the mutation value, '
          'then apply your friend boost and quantity.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Three simple steps',
              style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          for (var i = 0; i < _steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('${i + 1}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_steps[i].$1,
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(_steps[i].$2,
                            style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.55,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MutationRulesCard extends StatelessWidget {
  const _MutationRulesCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final byCategory = <MutationCategory, int>{};
    for (final m in MutationData.all) {
      byCategory.update(m.category, (v) => v + 1, ifAbsent: () => 1);
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mutation rules', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 14),
          _rule(theme, Icons.swap_horiz_rounded,
              'Growth mutations are exclusive',
              'A crop can be Gold or Rainbow — never both. Picking one clears the other.'),
          _rule(theme, Icons.layers_rounded, 'Environmentals stack',
              'You can hold several environmental mutations at once; they add into the (1 + Σ − count) term.'),
          _rule(theme, Icons.block_rounded, 'Some can\'t co-exist',
              'Wet, Chilled and Frozen are mutually exclusive, as are Cooked and Burnt. GrowVault swaps them automatically.'),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final entry in byCategory.entries)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: entry.key.color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                        color: entry.key.color.withValues(alpha: 0.4)),
                  ),
                  child: Text('${entry.key.label} · ${entry.value}',
                      style: TextStyle(
                          color: entry.key.color,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rule(ThemeData theme, IconData icon, String title, String body) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.7))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard();

  static const _faqs = [
    (
      'Why does weight matter so much?',
      'Because value scales with the square of the weight ratio. Small weight '
          'gains compound quickly, so heavier crops are disproportionately valuable.'
    ),
    (
      'Do mutations add or multiply?',
      'Growth mutations multiply directly. Environmental mutations combine '
          'inside the (1 + Σ − count) term, which behaves close to multiplying '
          'for large stacks.'
    ),
    (
      'What is the friend boost?',
      'A percentage bonus applied to the final value when selling with friends '
          'nearby. GrowVault lets you dial it from 0–100%.'
    ),
    (
      'Are these values official?',
      'Values mirror community-documented data and are curated for consistency. '
          'Game updates can shift them, so use GrowVault as a fast, reliable estimate.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Frequently asked', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          for (final f in _faqs)
            Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(bottom: 14),
                title: Text(f.$1, style: theme.textTheme.titleMedium),
                iconColor: theme.colorScheme.primary,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(f.$2,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.72))),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CtaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Text('Ready to crunch some numbers?',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('Jump into the calculator and see your crops\' true value.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.65))),
          const SizedBox(height: 18),
          GradientButton(
            label: 'Open Crop Calculator',
            icon: Icons.calculate_rounded,
            onPressed: () => context.go(Routes.calculator),
          ),
        ],
      ),
    );
  }
}
