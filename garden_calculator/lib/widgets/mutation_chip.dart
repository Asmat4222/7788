import 'package:flutter/material.dart';

import '../data/models/mutation.dart';

/// A selectable chip representing a mutation, showing its multiplier.
class MutationChip extends StatelessWidget {
  const MutationChip({
    super.key,
    required this.mutation,
    required this.selected,
    required this.onTap,
    this.disabled = false,
  });

  final Mutation mutation;
  final bool selected;
  final VoidCallback onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(mutation.color);
    final bg = selected
        ? color.withValues(alpha: 0.20)
        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    final borderColor = selected
        ? color.withValues(alpha: 0.9)
        : theme.colorScheme.outline;

    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: MouseRegion(
        cursor: disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: disabled ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: borderColor, width: selected ? 1.6 : 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(Icons.check_rounded, size: 15, color: color),
                  ),
                Text(
                  mutation.name,
                  style: TextStyle(
                    color: selected
                        ? color
                        : theme.colorScheme.onSurface
                            .withValues(alpha: 0.85),
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(width: 7),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '×${mutation.multiplier}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w800,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
