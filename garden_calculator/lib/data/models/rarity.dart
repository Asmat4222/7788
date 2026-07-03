import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Rarity tiers, mirroring the game's progression from Common to Transcendent.
enum Rarity {
  common('Common', Color(0xFF9CA3AF)),
  uncommon('Uncommon', Color(0xFF34D399)),
  rare('Rare', Color(0xFF38BDF8)),
  legendary('Legendary', Color(0xFFF59E0B)),
  mythical('Mythical', Color(0xFF8B5CF6)),
  divine('Divine', Color(0xFFF43F5E)),
  prismatic('Prismatic', Color(0xFFEC4899)),
  transcendent('Transcendent', Color(0xFF22D3EE));

  const Rarity(this.label, this.color);

  final String label;
  final Color color;

  /// A subtle gradient derived from the rarity colour for premium chips/cards.
  LinearGradient get gradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color.withValues(alpha: 0.9), color.withValues(alpha: 0.55)],
      );
}

/// Categories used to group and filter mutations in the UI.
enum MutationCategory {
  growth('Growth', AppColors.gold),
  environmental('Environmental', AppColors.sky),
  temperature('Temperature', Color(0xFF60A5FA)),
  cosmic('Cosmic', AppColors.violet),
  special('Special / Event', AppColors.rose);

  const MutationCategory(this.label, this.color);

  final String label;
  final Color color;
}
