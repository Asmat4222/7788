import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/rarity.dart';
import '../../widgets/animated_counter.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/page_container.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_tile.dart';

/// A lightweight pet in the estimator's catalogue.
class _Pet {
  const _Pet(this.name, this.emoji, this.baseValue, this.rarity);
  final String name;
  final String emoji;
  final int baseValue;
  final Rarity rarity;
}

const List<_Pet> _pets = [
  _Pet('Golden Lab', '🐕', 12000, Rarity.common),
  _Pet('Cat', '🐈', 18000, Rarity.uncommon),
  _Pet('Rabbit', '🐇', 45000, Rarity.rare),
  _Pet('Honey Bee', '🐝', 95000, Rarity.legendary),
  _Pet('Red Fox', '🦊', 180000, Rarity.legendary),
  _Pet('Polar Bear', '🐻‍❄️', 420000, Rarity.mythical),
  _Pet('Dragonfly', '🐉', 950000, Rarity.divine),
  _Pet('Raccoon', '🦝', 1650000, Rarity.divine),
  _Pet('Fennec Fox', '🦊', 3200000, Rarity.prismatic),
];

/// Estimates a pet's worth from its base value, age and weight. The model is
/// original to GrowVault — pets grow more valuable with age and mass.
class PetCalculatorScreen extends StatefulWidget {
  const PetCalculatorScreen({super.key});

  @override
  State<PetCalculatorScreen> createState() => _PetCalculatorScreenState();
}

class _PetCalculatorScreenState extends State<PetCalculatorScreen> {
  _Pet _pet = _pets.first;
  double _age = 1; // 1..100
  double _weight = 5; // kg

  /// Age adds up to +150% at max age; weight scales linearly from a 5kg norm.
  double get _ageMultiplier => 1 + (_age / 100.0) * 1.5;
  double get _weightMultiplier => (_weight / 5.0).clamp(0.2, 20);
  double get _value => _pet.baseValue * _ageMultiplier * _weightMultiplier;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final inputs = _InputsCard(
      pet: _pet,
      age: _age,
      weight: _weight,
      onPet: (p) => setState(() => _pet = p),
      onAge: (v) => setState(() => _age = v),
      onWeight: (v) => setState(() => _weight = v),
    );
    final result = _ResultCard(
      value: _value,
      ageMultiplier: _ageMultiplier,
      weightMultiplier: _weightMultiplier,
      baseValue: _pet.baseValue,
    );

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Calculator',
            title: 'Pet Value Estimator',
            subtitle:
                'Estimate a pet\'s worth from its species, age and weight.',
            icon: Icons.pets_rounded,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.sky.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.sky.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 18, color: AppColors.sky),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Pet values fluctuate with trading demand — treat these '
                    'as data-driven estimates, not fixed prices.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7),
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: inputs),
                const SizedBox(width: 22),
                Expanded(flex: 5, child: result),
              ],
            )
          else
            Column(children: [inputs, const SizedBox(height: 22), result]),
        ],
      ),
    );
  }
}

class _InputsCard extends StatelessWidget {
  const _InputsCard({
    required this.pet,
    required this.age,
    required this.weight,
    required this.onPet,
    required this.onAge,
    required this.onWeight,
  });

  final _Pet pet;
  final double age;
  final double weight;
  final ValueChanged<_Pet> onPet;
  final ValueChanged<double> onAge;
  final ValueChanged<double> onWeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pet', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final p in _pets)
                _PetChip(pet: p, selected: p.name == pet.name,
                    onTap: () => onPet(p)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text('Age', style: theme.textTheme.titleMedium),
              const Spacer(),
              Text('${age.toStringAsFixed(0)} / 100',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: AppColors.emeraldLight)),
            ],
          ),
          Slider(
            value: age,
            min: 1,
            max: 100,
            divisions: 99,
            label: age.toStringAsFixed(0),
            onChanged: onAge,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Weight', style: theme.textTheme.titleMedium),
              const Spacer(),
              Text(Formatters.weight(weight),
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: AppColors.sky)),
            ],
          ),
          Slider(
            value: weight,
            min: 0.5,
            max: 40,
            divisions: 79,
            label: Formatters.weight(weight),
            onChanged: onWeight,
          ),
        ],
      ),
    );
  }
}

class _PetChip extends StatelessWidget {
  const _PetChip(
      {required this.pet, required this.selected, required this.onTap});
  final _Pet pet;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? pet.rarity.color.withValues(alpha: 0.18)
              : theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected
                  ? pet.rarity.color
                  : theme.colorScheme.outline,
              width: selected ? 1.6 : 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(pet.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(pet.name,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: selected
                        ? pet.rarity.color
                        : theme.colorScheme.onSurface
                            .withValues(alpha: 0.85))),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.value,
    required this.ageMultiplier,
    required this.weightMultiplier,
    required this.baseValue,
  });
  final double value;
  final double ageMultiplier;
  final double weightMultiplier;
  final int baseValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withValues(alpha: 0.2),
                  AppColors.emerald.withValues(alpha: 0.14),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ESTIMATED VALUE',
                    style: theme.textTheme.labelMedium?.copyWith(
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.65))),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: AnimatedCounter(
                    value: value,
                    style: theme.textTheme.displayLarge!.copyWith(
                        color: AppColors.goldLight,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Text('${Formatters.compact(value)} sheckles',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.65))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: StatTile(
                  label: 'Base value',
                  value: '${Formatters.compact(baseValue)} 🪙',
                  icon: Icons.pets_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                  label: 'Age bonus',
                  value: Formatters.multiplier(ageMultiplier),
                  icon: Icons.cake_rounded,
                  accent: AppColors.emerald,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                  label: 'Weight',
                  value: Formatters.multiplier(weightMultiplier),
                  icon: Icons.scale_rounded,
                  accent: AppColors.sky,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
