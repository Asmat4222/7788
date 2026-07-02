import 'crop.dart';
import 'mutation.dart';

/// Immutable inputs for a crop-value calculation.
class CalculationInput {
  const CalculationInput({
    required this.crop,
    required this.weight,
    required this.quantity,
    required this.growth,
    required this.environmental,
    required this.friendBoostPercent,
  });

  final Crop crop;
  final double weight;
  final int quantity;

  /// The selected growth mutation, or null for none.
  final Mutation? growth;

  /// Selected environmental mutations (may be empty).
  final List<Mutation> environmental;

  /// Friend-boost bonus as a percentage (e.g. 10 => +10%).
  final double friendBoostPercent;
}

/// The fully-broken-down result of a calculation, suitable for rich UI.
class CalculationResult {
  const CalculationResult({
    required this.baseValue,
    required this.weightRatio,
    required this.weightMultiplier,
    required this.growthMultiplier,
    required this.environmentalTerm,
    required this.totalMultiplier,
    required this.friendBoostMultiplier,
    required this.singleValue,
    required this.totalValue,
  });

  final int baseValue;

  /// weight / baseWeight
  final double weightRatio;

  /// weightRatio squared
  final double weightMultiplier;

  /// Growth mutation multiplier (1 when none).
  final double growthMultiplier;

  /// The `(1 + Σmultipliers − count)` environmental term (1 when none).
  final double environmentalTerm;

  /// growthMultiplier × environmentalTerm — the combined mutation factor.
  final double totalMultiplier;

  /// 1 + friendBoost/100.
  final double friendBoostMultiplier;

  /// Value of one crop.
  final double singleValue;

  /// Value across the whole quantity, incl. friend boost.
  final double totalValue;
}
