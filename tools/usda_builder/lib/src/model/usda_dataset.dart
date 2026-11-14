import 'package:usda_builder/src/model/usda_food.dart';
import 'package:usda_builder/src/model/usda_nutrient.dart';

/// Everything the bundled file holds.
final class const UsdaDataset({
  /// The foods, ordered by FDC id.
  required final List<UsdaFood> foods,

  /// The nutrients the foods' amounts refer to, ordered by code.
  required final List<UsdaNutrient> nutrients,

  /// Facts about the build, such as which releases it came from.
  required final Map<String, String> metadata,
});
