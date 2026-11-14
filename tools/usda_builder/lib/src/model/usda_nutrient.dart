/// A nutrient the bundled file carries.
final class const UsdaNutrient({
  /// The USDA nutrient number, such as "208" for energy in kcal. This is the
  /// app's `FoodNutrient.nutrientCode`.
  required final String code,

  /// USDA's name, such as "Energy".
  required final String name,

  /// The unit of every amount of this nutrient: "g", "mg", "ug", or "kcal".
  required final String unit,
});
