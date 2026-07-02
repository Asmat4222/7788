import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/responsive.dart';
import '../../data/datasources/crop_data.dart';
import '../../data/models/crop.dart';
import '../../data/models/rarity.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/page_container.dart';
import '../../widgets/rarity_badge.dart';
import '../../widgets/section_header.dart';

enum _Sort { valueDesc, valueAsc, nameAsc, weightDesc }

/// Browsable, filterable catalogue of every crop.
class CropDatabaseScreen extends ConsumerStatefulWidget {
  const CropDatabaseScreen({super.key});

  @override
  ConsumerState<CropDatabaseScreen> createState() =>
      _CropDatabaseScreenState();
}

class _CropDatabaseScreenState extends ConsumerState<CropDatabaseScreen> {
  String _query = '';
  Rarity? _rarity;
  _Sort _sort = _Sort.valueDesc;

  List<Crop> get _filtered {
    var list = CropData.search(_query);
    if (_rarity != null) {
      list = list.where((c) => c.rarity == _rarity).toList();
    }
    list = [...list];
    switch (_sort) {
      case _Sort.valueDesc:
        list.sort((a, b) => b.baseValue.compareTo(a.baseValue));
      case _Sort.valueAsc:
        list.sort((a, b) => a.baseValue.compareTo(b.baseValue));
      case _Sort.nameAsc:
        list.sort((a, b) => a.name.compareTo(b.name));
      case _Sort.weightDesc:
        list.sort((a, b) => b.baseWeight.compareTo(a.baseWeight));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;
    final columns =
        Responsive.gridColumns(context, mobile: 1, tablet: 2, desktop: 3);

    return PageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            eyebrow: 'Database',
            title: 'Crop Database',
            subtitle:
                '${CropData.all.length} crops across ${Rarity.values.length} rarity tiers.',
            icon: Icons.grid_view_rounded,
          ),
          const SizedBox(height: 22),
          _Filters(
            query: _query,
            rarity: _rarity,
            sort: _sort,
            onQuery: (v) => setState(() => _query = v),
            onRarity: (r) => setState(() => _rarity = r),
            onSort: (s) => setState(() => _sort = s),
          ),
          const SizedBox(height: 20),
          if (results.isEmpty)
            _EmptyState(query: _query)
          else
            LayoutBuilder(builder: (context, c) {
              const gap = 16.0;
              final w = (c.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final crop in results)
                    SizedBox(width: w, child: _CropCard(crop: crop)),
                ],
              );
            }),
        ],
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.query,
    required this.rarity,
    required this.sort,
    required this.onQuery,
    required this.onRarity,
    required this.onSort,
  });

  final String query;
  final Rarity? rarity;
  final _Sort sort;
  final ValueChanged<String> onQuery;
  final ValueChanged<Rarity?> onRarity;
  final ValueChanged<_Sort> onSort;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search crops…',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                  onChanged: onQuery,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: PopupMenuButton<_Sort>(
                  tooltip: 'Sort',
                  onSelected: onSort,
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                        value: _Sort.valueDesc,
                        child: Text('Value: high → low')),
                    PopupMenuItem(
                        value: _Sort.valueAsc,
                        child: Text('Value: low → high')),
                    PopupMenuItem(
                        value: _Sort.nameAsc, child: Text('Name: A → Z')),
                    PopupMenuItem(
                        value: _Sort.weightDesc,
                        child: Text('Weight: heavy → light')),
                  ],
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Icon(Icons.sort_rounded),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _RarityFilterChip(
                  label: 'All',
                  color: theme.colorScheme.primary,
                  selected: rarity == null,
                  onTap: () => onRarity(null),
                ),
                for (final r in Rarity.values)
                  _RarityFilterChip(
                    label: r.label,
                    color: r.color,
                    selected: rarity == r,
                    onTap: () => onRarity(r),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RarityFilterChip extends StatelessWidget {
  const _RarityFilterChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
                color: selected
                    ? color.withValues(alpha: 0.8)
                    : Theme.of(context).colorScheme.outline),
          ),
          child: Text(label,
              style: TextStyle(
                  color: selected
                      ? color
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.75),
                  fontWeight: FontWeight.w700,
                  fontSize: 13)),
        ),
      ),
    );
  }
}

class _CropCard extends StatelessWidget {
  const _CropCard({required this.crop});
  final Crop crop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      hoverLift: true,
      padding: const EdgeInsets.all(18),
      onTap: () => context.go(Routes.calculator),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: crop.rarity.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(crop.emoji, style: const TextStyle(fontSize: 30)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(crop.name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 5),
                    RarityBadge(rarity: crop.rarity, compact: true),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _miniStat(theme, 'Base value',
                    '${Formatters.sheckles(crop.baseValue)} 🪙',
                    AppColors.goldLight),
              ),
              Expanded(
                child: _miniStat(theme, 'Base weight',
                    '${crop.baseWeight} kg', AppColors.sky),
              ),
            ],
          ),
          if (crop.multiHarvest) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.autorenew_rounded,
                    size: 15, color: AppColors.emeraldLight),
                const SizedBox(width: 6),
                Text('Multi-harvest',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.emeraldLight,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _miniStat(
      ThemeData theme, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 0.6,
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.5))),
        const SizedBox(height: 3),
        Text(value,
            style: theme.textTheme.titleMedium
                ?.copyWith(color: color, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const Text('🌱', style: TextStyle(fontSize: 54)),
          const SizedBox(height: 16),
          Text('No crops found', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            query.isEmpty
                ? 'Try adjusting your filters.'
                : 'Nothing matches "$query". Try another search.',
            style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}
