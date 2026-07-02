import 'rarity.dart';

/// A single plant/crop in the Grow a Garden universe.
///
/// [baseValue] is the sell price in sheckles at [baseWeight] with no
/// mutations. [emoji] is used as a lightweight, original visual token — the
/// reference site's icons and artwork are deliberately not reused.
class Crop {
  const Crop({
    required this.id,
    required this.name,
    required this.baseValue,
    required this.baseWeight,
    required this.rarity,
    required this.emoji,
    this.multiHarvest = false,
  });

  final String id;
  final String name;
  final int baseValue;
  final double baseWeight;
  final Rarity rarity;
  final String emoji;

  /// Whether the plant regrows and can be harvested repeatedly.
  final bool multiHarvest;

  /// Sheckles-per-kg efficiency at base weight — used for sorting/insights.
  double get valuePerKg => baseValue / baseWeight;
}
