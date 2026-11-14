import 'package:usda_builder/src/fdc/fdc_portion.dart';

/// A food as it appears in a FoodData Central release.
final class const FdcFood({
  /// The FoodData Central id, unique across every data type.
  required final int fdcId,

  /// USDA's name for the food, such as "Broccoli, raw".
  required final String description,

  /// Nutrient amounts per 100 g, keyed by USDA nutrient number ("203").
  required final Map<String, double> nutrients,

  /// Household portions with their gram weights.
  required final List<FdcPortion> portions,
});
