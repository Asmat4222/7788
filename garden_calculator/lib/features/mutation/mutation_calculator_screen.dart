import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/responsive.dart';
import '../../data/datasources/mutation_data.dart';
import '../../data/models/mutation.dart';
import '../../data/models/rarity.dart';
import '../../widgets/animated_counter.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/mutation_chip.dart';
import '../../widgets/page_container.dart';
import '../../widgets/section_header.dart';

/// A standalone mutation stacker: pick any mutations and see the combined
/// multiplier, with an optional base value to project the final worth.
class MutationCalculatorScreen extends ConsumerStatefulWidget {
  const MutationCalculatorScreen({super.key});

  @override
  ConsumerState<MutationCalculatorScreen> createState() =>
      _MutationCalculatorScreenState();
}

class _MutationCalculatorScreenState
    extends ConsumerState<MutationCalculatorScreen> {
  final Set<String> _selected = {};
  double _baseValue = 100;

  List<Mutation> get _selectedMutations =>
      MutationData.all.where((m) => _selected.contains(m.id)).toList();

  void _toggle(Mutation m) {
    setState(() {
      if (_selected.contains(m.id)) {
        _selected.remove(m.id);
        return;
      }
      // Growth mutations are mutually exclusive.
      if (m.isGrowth) {
        for (final g in MutationData.growth) {
          _selected.remove(g.id);
        }
      }
      // Honour declared conflicts.
      _selected.removeWhere((id) {
        final other = MutationData.byId(id);
        return other != null &&
            (m.conflicts.contains(id) || other.conflicts.contains(m.id));
      });
      _selected.add(m.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.read(calculatorServiceProvider);
    final multiplier = service.combinedMultiplier(_selectedMutations);
    final isDesktop = Responsive.isDesktop(context);

    final selector = _Selector(
      selectedIds: _selected,
      onToggle: _toggle,
      onClear: () => setState(_selected.clear),
    );
    final result = _ResultCard(
      multiplier: multiplier,
      baseValue: _baseValue,
      selectedCount: _selectedMutations.length,
      onBaseChanged: (v) => setState(() => _baseValue = v),
    );

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Calculator',
            title: 'Mutation Stacker',
            subtitle:
                'Mutations multiply — see exactly how big a stack gets. '
                'Growth mutations are exclusive; conflicting environmentals '
                'auto-swap.',
            icon: Icons.auto_awesome_rounded,
          ),
          const SizedBox(height: 24),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: selector),
                const SizedBox(width: 22),
                Expanded(flex: 5, child: result),
              ],
            )
          else
            Column(children: [selector, const SizedBox(height: 22), result]),
        ],
      ),
    );
  }
}

class _Selector extends StatelessWidget {
  const _Selector({
    required this.selectedIds,
    required this.onToggle,
    required this.onClear,
  });

  final Set<String> selectedIds;
  final void Function(Mutation) onToggle;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final byCategory = <MutationCategory, List<Mutation>>{};
    for (final m in MutationData.all) {
      byCategory.putIfAbsent(m.category, () => []).add(m);
    }

    return GlassCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Choose mutations',
                    style: theme.textTheme.titleLarge),
              ),
              if (selectedIds.isNotEmpty)
                TextButton(
                    onPressed: onClear,
                    child: Text('Clear (${selectedIds.length})')),
            ],
          ),
          for (final entry in byCategory.entries) ...[
            Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 10),
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
                      style: theme.textTheme.labelSmall?.copyWith(
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6))),
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
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.multiplier,
    required this.baseValue,
    required this.selectedCount,
    required this.onBaseChanged,
  });

  final double multiplier;
  final double baseValue;
  final int selectedCount;
  final ValueChanged<double> onBaseChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projected = baseValue * multiplier;

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.cosmicGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('COMBINED MULTIPLIER',
                    style: TextStyle(
                        color: Colors.white70,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: AnimatedCounter(
                    value: multiplier,
                    prefix: '×',
                    compact: multiplier >= 100000,
                    style: theme.textTheme.displayLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedCount == 0
                      ? 'Select mutations to begin'
                      : '$selectedCount mutation${selectedCount == 1 ? '' : 's'} stacked',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text('Project onto a base value',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.sell_rounded),
              suffixText: '🪙 base',
              hintText: '100',
            ),
            onChanged: (v) {
              final parsed = double.tryParse(v);
              if (parsed != null) onBaseChanged(parsed);
            },
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PROJECTED VALUE',
                          style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.2,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6))),
                      const SizedBox(height: 6),
                      Text('${Formatters.sheckles(projected)} 🪙',
                          style: theme.textTheme.headlineMedium?.copyWith(
                              color: AppColors.goldLight,
                              fontWeight: FontWeight.w800)),
                      Text('${Formatters.compact(projected)} sheckles',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.55))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Growth mutations apply a flat multiplier; environmental '
            'mutations combine as 1 + Σ(multipliers) − count.',
            style: theme.textTheme.bodySmall?.copyWith(
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.6),
                height: 1.5),
          ),
        ],
      ),
    );
  }
}
