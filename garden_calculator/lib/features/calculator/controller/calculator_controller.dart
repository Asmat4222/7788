import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/datasources/crop_data.dart';
import '../../../data/models/calculation.dart';
import '../../../data/models/crop.dart';
import '../../../data/models/mutation.dart';

/// Immutable state for the crop-value calculator screen.
class CalculatorState {
  const CalculatorState({
    required this.crop,
    required this.weight,
    required this.quantity,
    required this.growth,
    required this.environmental,
    required this.friendBoostPercent,
    required this.useBaseWeight,
    this.result,
  });

  final Crop crop;
  final double weight;
  final int quantity;
  final Mutation? growth;
  final List<Mutation> environmental;
  final double friendBoostPercent;
  final bool useBaseWeight;
  final CalculationResult? result;

  CalculatorState copyWith({
    Crop? crop,
    double? weight,
    int? quantity,
    Object? growth = _sentinel,
    List<Mutation>? environmental,
    double? friendBoostPercent,
    bool? useBaseWeight,
    CalculationResult? result,
  }) {
    return CalculatorState(
      crop: crop ?? this.crop,
      weight: weight ?? this.weight,
      quantity: quantity ?? this.quantity,
      growth: growth == _sentinel ? this.growth : growth as Mutation?,
      environmental: environmental ?? this.environmental,
      friendBoostPercent: friendBoostPercent ?? this.friendBoostPercent,
      useBaseWeight: useBaseWeight ?? this.useBaseWeight,
      result: result ?? this.result,
    );
  }

  static const Object _sentinel = Object();
}

/// Drives the crop-value calculator: holds selections and recomputes results.
class CalculatorController extends StateNotifier<CalculatorState> {
  CalculatorController(this._ref)
      : super(CalculatorState(
          crop: CropData.all.first,
          weight: CropData.all.first.baseWeight,
          quantity: 1,
          growth: null,
          environmental: const [],
          friendBoostPercent: 0,
          useBaseWeight: true,
        )) {
    _recompute();
  }

  final Ref _ref;

  void selectCrop(Crop crop) {
    // When locked to base weight, follow the crop's base weight automatically.
    final newWeight = state.useBaseWeight ? crop.baseWeight : state.weight;
    state = state.copyWith(crop: crop, weight: newWeight);
    _recompute();
  }

  void setWeight(double weight) {
    state = state.copyWith(
        weight: weight.clamp(0.01, 100000), useBaseWeight: false);
    _recompute();
  }

  void resetWeightToBase() {
    state = state.copyWith(weight: state.crop.baseWeight, useBaseWeight: true);
    _recompute();
  }

  void setQuantity(int quantity) {
    state = state.copyWith(quantity: quantity.clamp(1, 100000));
    _recompute();
  }

  void setGrowth(Mutation? growth) {
    state = state.copyWith(growth: growth);
    _recompute();
  }

  void toggleEnvironmental(Mutation mutation) {
    final current = [...state.environmental];
    final exists = current.any((m) => m.id == mutation.id);
    if (exists) {
      current.removeWhere((m) => m.id == mutation.id);
    } else {
      // Drop any conflicting selections before adding the new one.
      current.removeWhere((m) =>
          mutation.conflicts.contains(m.id) || m.conflicts.contains(mutation.id));
      current.add(mutation);
    }
    state = state.copyWith(environmental: current);
    _recompute();
  }

  void clearEnvironmental() {
    state = state.copyWith(environmental: const []);
    _recompute();
  }

  void setFriendBoost(double percent) {
    state = state.copyWith(friendBoostPercent: percent.clamp(0, 100));
    _recompute();
  }

  void resetAll() {
    final crop = CropData.all.first;
    state = CalculatorState(
      crop: crop,
      weight: crop.baseWeight,
      quantity: 1,
      growth: null,
      environmental: const [],
      friendBoostPercent: 0,
      useBaseWeight: true,
    );
    _recompute();
  }

  void _recompute() {
    final service = _ref.read(calculatorServiceProvider);
    final result = service.calculate(CalculationInput(
      crop: state.crop,
      weight: state.weight,
      quantity: state.quantity,
      growth: state.growth,
      environmental: state.environmental,
      friendBoostPercent: state.friendBoostPercent,
    ));
    state = state.copyWith(result: result);
  }
}

final calculatorControllerProvider =
    StateNotifierProvider<CalculatorController, CalculatorState>((ref) {
  return CalculatorController(ref);
});
