import '../datasources/crop_data.dart';
import '../datasources/mutation_data.dart';
import '../models/crop.dart';
import '../models/mutation.dart';
import '../models/rarity.dart';

/// A thin repository that abstracts the static data sources. In a production
/// app this is where a remote API, cache or database would be wired in — the
/// rest of the app depends only on this interface.
class GardenRepository {
  const GardenRepository();

  List<Crop> crops() => CropData.all;

  Crop crop(String id) => CropData.byId(id);

  List<Crop> searchCrops(String query) => CropData.search(query);

  List<Crop> cropsByRarity(Rarity rarity) => CropData.ofRarity(rarity);

  List<Mutation> growthMutations() => MutationData.growth;

  List<Mutation> environmentalMutations() => MutationData.environmental;

  List<Mutation> allMutations() => MutationData.all;

  Mutation? mutation(String id) => MutationData.byId(id);

  List<Mutation> mutationsByCategory(MutationCategory category) =>
      MutationData.ofCategory(category);
}
