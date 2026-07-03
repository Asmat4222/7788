import 'dart:math' as math;

import '../data/models/calculation.dart';
import '../data/models/mutation.dart';

/// Pure calculation engine for Grow a Garden crop values.
///
/// Implements the community-documented three-step formula:
///
///   1. Weight factor      = (weight / baseWeight)²
///   2. Environmental term = 1 + Σ(envMultipliers) − envCount
///   3. Final value        = baseValue × weightFactor × growthMult × envTerm
///
/// The friend boost (a percentage bonus) and quantity are applied last. The
/// class is intentionally free of any Flutter dependency so it can be unit
/// tested in isolation.
class CalculatorService {
  const CalculatorService();

  /// Minimum weight ratio the game clamps to (a crop is never worth less than
  /// a fraction of its base). Kept small to preserve tiny-crop realism.
  static const double _minWeightRatio = 0.1;

  CalculationResult calculate(CalculationInput input) {
    final baseValue = input.crop.baseValue;
    final baseWeight = input.crop.baseWeight <= 0 ? 1.0 : input.crop.baseWeight;

    final rawRatio = input.weight / baseWeight;
    final weightRatio = math.max(rawRatio, _minWeightRatio);
    final weightMultiplier = weightRatio * weightRatio;

    final growthMultiplier =
        input.growth == null ? 1.0 : input.growth!.multiplier.toDouble();

    final environmentalTerm = _environmentalTerm(input.environmental);

    final totalMultiplier = growthMultiplier * environmentalTerm;

    final friendBoostMultiplier = 1 + (input.friendBoostPercent / 100.0);

    final singleValue =
        baseValue * weightMultiplier * totalMultiplier * friendBoostMultiplier;

    final totalValue = singleValue * input.quantity;

    return CalculationResult(
      baseValue: baseValue,
      weightRatio: weightRatio,
      weightMultiplier: weightMultiplier,
      growthMultiplier: growthMultiplier,
      environmentalTerm: environmentalTerm,
      totalMultiplier: totalMultiplier,
      friendBoostMultiplier: friendBoostMultiplier,
      singleValue: singleValue,
      totalValue: totalValue,
    );
  }

  /// `1 + Σmultipliers − count`. With no environmental mutations this is 1.
  double _environmentalTerm(List<Mutation> mutations) {
    if (mutations.isEmpty) return 1;
    final sum =
        mutations.fold<int>(0, (acc, m) => acc + m.multiplier);
    return 1 + sum - mutations.length;
  }

  /// Combined multiplier for a bare list of mutations (used by the standalone
  /// mutation calculator). Growth mutations multiply directly; environmental
  /// mutations feed the `(1 + Σ − count)` term.
  double combinedMultiplier(List<Mutation> mutations) {
    final growth = mutations.where((m) => m.isGrowth);
    final env = mutations.where((m) => !m.isGrowth).toList();

    final growthMult = growth.fold<double>(
        1, (acc, m) => acc * m.multiplier.toDouble());
    return growthMult * _environmentalTerm(env);
  }
}
