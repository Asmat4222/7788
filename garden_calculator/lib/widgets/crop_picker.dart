import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../data/datasources/crop_data.dart';
import '../data/models/crop.dart';
import 'rarity_badge.dart';

/// A tappable field that opens a searchable crop selector sheet.
class CropPickerField extends StatelessWidget {
  const CropPickerField({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final Crop selected;
  final ValueChanged<Crop> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
      onTap: () async {
        final crop = await showModalBottomSheet<Crop>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => _CropPickerSheet(selectedId: selected.id),
        );
        if (crop != null) onSelected(crop);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          children: [
            Text(selected.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(selected.name, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 3),
                  RarityBadge(rarity: selected.rarity, compact: true),
                ],
              ),
            ),
            Icon(Icons.unfold_more_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _CropPickerSheet extends StatefulWidget {
  const _CropPickerSheet({required this.selectedId});
  final String selectedId;

  @override
  State<_CropPickerSheet> createState() => _CropPickerSheetState();
}

class _CropPickerSheetState extends State<_CropPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = CropData.search(_query);

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.94,
      expand: false,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Choose a crop',
                          style: theme.textTheme.headlineSmall),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search crops…',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: results.isEmpty
                    ? _EmptyResults(query: _query)
                    : ListView.builder(
                        controller: controller,
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                        itemCount: results.length,
                        itemBuilder: (context, i) {
                          final crop = results[i];
                          final selected = crop.id == widget.selectedId;
                          return _CropRow(
                            crop: crop,
                            selected: selected,
                            onTap: () => Navigator.of(context).pop(crop),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CropRow extends StatelessWidget {
  const _CropRow(
      {required this.crop, required this.selected, required this.onTap});
  final Crop crop;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: selected
            ? theme.colorScheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Text(crop.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(crop.name, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 3),
                      RarityBadge(rarity: crop.rarity, compact: true),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${crop.baseValue} 🪙',
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700)),
                    Text('${crop.baseWeight} kg base',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5))),
                  ],
                ),
                if (selected) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.check_circle_rounded,
                      color: theme.colorScheme.primary, size: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔎', style: TextStyle(fontSize: 44)),
          const SizedBox(height: 12),
          Text('No crops match "$query"',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text('Try a different name.',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.6))),
        ],
      ),
    );
  }
}
