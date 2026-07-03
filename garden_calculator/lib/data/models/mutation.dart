import 'rarity.dart';

/// A mutation that alters a crop's final value.
///
/// Growth mutations (Gold, Rainbow) are mutually exclusive and act as a direct
/// multiplier. Environmental mutations stack additively inside the game's
/// `(1 + Σmultipliers − count)` term.
class Mutation {
  const Mutation({
    required this.id,
    required this.name,
    required this.multiplier,
    required this.category,
    required this.color,
    this.description = '',
    this.conflicts = const [],
  });

  final String id;
  final String name;

  /// The raw multiplier value shown to players (e.g. Shocked = 100).
  final int multiplier;

  final MutationCategory category;

  /// Accent colour (int ARGB) so the model stays free of Flutter imports at
  /// the data layer boundary; converted where rendered.
  final int color;

  final String description;

  /// IDs of mutations that cannot co-exist with this one.
  final List<String> conflicts;

  bool get isGrowth => category == MutationCategory.growth;
}
