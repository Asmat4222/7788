import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/garden_repository.dart';
import '../../services/calculator_service.dart';

/// Root dependency providers, injected once and reused everywhere.
final gardenRepositoryProvider = Provider<GardenRepository>((ref) {
  return const GardenRepository();
});

final calculatorServiceProvider = Provider<CalculatorService>((ref) {
  return const CalculatorService();
});
