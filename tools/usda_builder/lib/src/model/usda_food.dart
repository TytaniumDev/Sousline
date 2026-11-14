import 'package:usda_builder/src/model/usda_portion.dart';

/// A food as it is written to the bundled file.
final class const UsdaFood({
  /// The FoodData Central id.
  required final int fdcId,

  /// USDA's name for the food.
  required final String name,

  /// Amounts per 100 g, keyed by the nutrient codes in `usdaNutrients`.
  required final Map<String, double> nutrients,

  /// Household portions, in the release's order.
  required final List<UsdaPortion> portions,
}) {
  /// The app's `FoodId` for this food.
  String get id => 'usda:$fdcId';
}
