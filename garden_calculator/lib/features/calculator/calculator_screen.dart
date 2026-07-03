import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/responsive.dart';
import '../../data/datasources/mutation_data.dart';
import '../../data/models/mutation.dart';
import '../../data/models/rarity.dart';
import '../../widgets/animated_counter.dart';
import '../../widgets/crop_picker.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/mutation_chip.dart';
import '../../widgets/page_container.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_tile.dart';
import 'controller/calculator_controller.dart';

/// The flagship crop-value calculator.
class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = Responsive.isDesktop(context);

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Calculator',
            title: 'Crop Value Calculator',
            subtitle:
                'Pick a crop, dial in weight and mutations, and watch the '
                'value update instantly.',
            icon: Icons.calculate_rounded,
          ),
          const SizedBox(height: 24),
          if (isDesktop)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(flex: 6, child: _InputsPanel()),
                  SizedBox(width: 22),
                  Expanded(flex: 5, child: _ResultsPanel()),
                ],
              ),
            )
          else
            Column(
              children: const [
                _InputsPanel(),
                SizedBox(height: 22),
                _ResultsPanel(),
              ],
            ),
        ],
      ),
    );
  }
}

class _InputsPanel extends ConsumerWidget {
  const _InputsPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorControllerProvider);
    final controller = ref.read(calculatorControllerProvider.notifier);
    final theme = Theme.of(context);

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(context, 'Crop'),
          CropPickerField(
            selected: state.crop,
            onSelected: controller.selectCrop,
          ),
          const SizedBox(height: 22),

          // Weight
          Row(
            children: [
              _label(context, 'Weight (kg)'),
              const Spacer(),
              TextButton.icon(
                onPressed: controller.resetWeightToBase,
                icon: const Icon(Icons.restart_alt_rounded, size: 16),
                label: Text('Base ${state.crop.baseWeight} kg'),
                style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact),
              ),
            ],
          ),
          _WeightField(
            weight: state.weight,
            onChanged: controller.setWeight,
          ),
          const SizedBox(height: 8),
          _WeightSlider(
            weight: state.weight,
            baseWeight: state.crop.baseWeight,
            onChanged: controller.setWeight,
          ),
          const SizedBox(height: 22),

          // Quantity
          _label(context, 'Quantity'),
          _QuantityStepper(
            quantity: state.quantity,
            onChanged: controller.setQuantity,
          ),
          const SizedBox(height: 22),

          // Growth mutation
          Row(
            children: [
              _label(context, 'Growth mutation'),
              const Spacer(),
              Text('one of',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.5))),
            ],
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _GrowthOption(
                label: 'None',
                selected: state.growth == null,
                onTap: () => controller.setGrowth(null),
              ),
              for (final m in MutationData.growth)
                MutationChip(
                  mutation: m,
                  selected: state.growth?.id == m.id,
                  onTap: () => controller.setGrowth(
                      state.growth?.id == m.id ? null : m),
                ),
            ],
          ),
          const SizedBox(height: 22),

          // Environmental mutations
          Row(
            children: [
              _label(context, 'Environmental mutations'),
              const Spacer(),
              if (state.environmental.isNotEmpty)
                TextButton(
                  onPressed: controller.clearEnvironmental,
                  child: Text('Clear (${state.environmental.length})'),
                ),
            ],
          ),
          const SizedBox(height: 4),
          _EnvironmentalSelector(
            selectedIds:
                state.environmental.map((m) => m.id).toSet(),
            onToggle: controller.toggleEnvironmental,
          ),
          const SizedBox(height: 22),

          // Friend boost
          Row(
            children: [
              _label(context, 'Friend boost'),
              const Spacer(),
              Text('+${state.friendBoostPercent.toStringAsFixed(0)}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.emeraldLight)),
            ],
          ),
          Slider(
            value: state.friendBoostPercent,
            min: 0,
            max: 100,
            divisions: 20,
            label: '+${state.friendBoostPercent.toStringAsFixed(0)}%',
            onChanged: controller.setFriendBoost,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: controller.resetAll,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reset all'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _GrowthOption extends StatelessWidget {
  const _GrowthOption(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.18)
              : theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface
                        .withValues(alpha: 0.85))),
      ),
    );
  }
}

class _WeightField extends StatefulWidget {
  const _WeightField({required this.weight, required this.onChanged});
  final double weight;
  final ValueChanged<double> onChanged;

  @override
  State<_WeightField> createState() => _WeightFieldState();
}

class _WeightFieldState extends State<_WeightField> {
  late final TextEditingController _c =
      TextEditingController(text: _fmt(widget.weight));

  String _fmt(double v) => v.toStringAsFixed(2);

  @override
  void didUpdateWidget(covariant _WeightField old) {
    super.didUpdateWidget(old);
    // Sync when weight changes externally (e.g. crop change / slider).
    final parsed = double.tryParse(_c.text);
    if (parsed == null || (parsed - widget.weight).abs() > 0.001) {
      _c.text = _fmt(widget.weight);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _c,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.scale_rounded),
        suffixText: 'kg',
      ),
      onChanged: (v) {
        final parsed = double.tryParse(v);
        if (parsed != null && parsed > 0) widget.onChanged(parsed);
      },
    );
  }
}

class _WeightSlider extends StatelessWidget {
  const _WeightSlider({
    required this.weight,
    required this.baseWeight,
    required this.onChanged,
  });
  final double weight;
  final double baseWeight;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    // Slider spans roughly 0.1× to 8× base weight for a useful range.
    final max = (baseWeight * 8).clamp(1.0, 100000.0);
    final value = weight.clamp(0.01, max);
    return Slider(
      value: value.toDouble(),
      min: 0.01,
      max: max.toDouble(),
      label: Formatters.weight(value),
      onChanged: onChanged,
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper(
      {required this.quantity, required this.onChanged});
  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          _stepBtn(context, Icons.remove_rounded,
              () => onChanged(quantity - 1)),
          Expanded(
            child: Text('$quantity',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge),
          ),
          _stepBtn(
              context, Icons.add_rounded, () => onChanged(quantity + 1)),
        ],
      ),
    );
  }

  Widget _stepBtn(BuildContext context, IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _EnvironmentalSelector extends StatelessWidget {
  const _EnvironmentalSelector(
      {required this.selectedIds, required this.onToggle});
  final Set<String> selectedIds;
  final void Function(Mutation mutation) onToggle;

  @override
  Widget build(BuildContext context) {
    // Group by category for readability.
    final byCategory = <MutationCategory, List<Mutation>>{};
    for (final m in MutationData.environmental) {
      byCategory.putIfAbsent(m.category, () => []).add(m);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in byCategory.entries) ...[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: entry.key.color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(entry.key.label.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                        )),
              ],
            ),
          ),
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              for (final m in entry.value)
                MutationChip(
                  mutation: m,
                  selected: selectedIds.contains(m.id),
                  onTap: () => onToggle(m),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ResultsPanel extends ConsumerWidget {
  const _ResultsPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorControllerProvider);
    final theme = Theme.of(context);
    final result = state.result;
    if (result == null) return const SizedBox.shrink();

    final columns = Responsive.isMobile(context) ? 2 : 2;

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Big total
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.emerald.withValues(alpha: 0.20),
                  AppColors.gold.withValues(alpha: 0.14),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('TOTAL VALUE',
                        style: theme.textTheme.labelMedium?.copyWith(
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.65))),
                    const Spacer(),
                    if (state.quantity > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              AppColors.emerald.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text('×${state.quantity}',
                            style: const TextStyle(
                                color: AppColors.emeraldLight,
                                fontWeight: FontWeight.w800)),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AnimatedCounter(
                        value: result.totalValue,
                        style: theme.textTheme.displayLarge!.copyWith(
                          color: AppColors.goldLight,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 6, left: 8),
                        child: Text('🪙',
                            style: TextStyle(fontSize: 26)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${Formatters.compact(result.totalValue)} sheckles · '
                  '${Formatters.sheckles(result.singleValue)} each',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.65)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text('Breakdown', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.9,
            children: [
              StatTile(
                label: 'Base value',
                value: '${Formatters.sheckles(result.baseValue)} 🪙',
                icon: Icons.sell_rounded,
              ),
              StatTile(
                label: 'Weight factor',
                value: Formatters.multiplier(result.weightMultiplier),
                sub: '${result.weightRatio.toStringAsFixed(2)}× ratio²',
                icon: Icons.scale_rounded,
                accent: AppColors.sky,
              ),
              StatTile(
                label: 'Growth',
                value: Formatters.multiplier(result.growthMultiplier),
                icon: Icons.auto_awesome_rounded,
                accent: AppColors.violet,
              ),
              StatTile(
                label: 'Environmental',
                value: Formatters.multiplier(result.environmentalTerm),
                sub: '1 + Σ − count',
                icon: Icons.thermostat_rounded,
                accent: AppColors.gold,
              ),
              StatTile(
                label: 'Total multiplier',
                value: Formatters.multiplier(result.totalMultiplier),
                icon: Icons.close_rounded,
                accent: AppColors.emerald,
              ),
              StatTile(
                label: 'Friend boost',
                value: Formatters.multiplier(result.friendBoostMultiplier),
                icon: Icons.group_rounded,
                accent: AppColors.emeraldLight,
              ),
            ],
          ),
          const SizedBox(height: 18),
          _FormulaHint(),
        ],
      ),
    );
  }
}

class _FormulaHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.functions_rounded,
              size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Value = Base × (Weight ÷ Base Weight)² × Growth × '
              '(1 + Σ Env − count) × Friend Boost',
              style: theme.textTheme.bodySmall?.copyWith(
                fontFeatures: const [],
                height: 1.5,
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
