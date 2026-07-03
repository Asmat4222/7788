import 'package:flutter_test/flutter_test.dart';
import 'package:garden_calculator/data/datasources/crop_data.dart';
import 'package:garden_calculator/data/datasources/mutation_data.dart';
import 'package:garden_calculator/data/models/calculation.dart';
import 'package:garden_calculator/services/calculator_service.dart';

void main() {
  const service = CalculatorService();
  final carrot = CropData.byId('carrot');

  CalculationInput input({
    double? weight,
    int quantity = 1,
    growth,
    List env = const [],
    double friend = 0,
  }) {
    return CalculationInput(
      crop: carrot,
      weight: weight ?? carrot.baseWeight,
      quantity: quantity,
      growth: growth,
      environmental: List.castFrom(env),
      friendBoostPercent: friend,
    );
  }

  test('base weight with no mutations returns roughly base value', () {
    final r = service.calculate(input());
    expect(r.weightMultiplier, closeTo(1.0, 0.001));
    expect(r.totalMultiplier, 1.0);
    expect(r.singleValue, closeTo(carrot.baseValue.toDouble(), 0.5));
  });

  test('weight factor is squared', () {
    final r = service.calculate(input(weight: carrot.baseWeight * 2));
    expect(r.weightMultiplier, closeTo(4.0, 0.001));
  });

  test('growth mutation multiplies directly', () {
    final gold = MutationData.byId('gold');
    final r = service.calculate(input(growth: gold));
    expect(r.growthMultiplier, 20);
    expect(r.totalMultiplier, 20);
  });

  test('environmental term follows 1 + sum - count', () {
    final shocked = MutationData.byId('shocked')!; // 100
    final wet = MutationData.byId('wet')!; // 2
    final r = service.calculate(input(env: [shocked, wet]));
    // 1 + (100 + 2) - 2 = 101
    expect(r.environmentalTerm, 101);
  });

  test('quantity and friend boost apply at the end', () {
    final r = service.calculate(input(quantity: 3, friend: 10));
    expect(r.friendBoostMultiplier, closeTo(1.1, 0.0001));
    expect(r.totalValue, closeTo(r.singleValue * 3, 0.001));
  });

  test('combined multiplier stacks growth and environmentals', () {
    final rainbow = MutationData.byId('rainbow')!; // 50
    final shocked = MutationData.byId('shocked')!; // 100
    // growth 50 * (1 + 100 - 1) = 50 * 100 = 5000
    final m = service.combinedMultiplier([rainbow, shocked]);
    expect(m, 5000);
  });
}
