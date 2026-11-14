/// A nutrient definition from a FoodData Central `nutrient.csv` row.
final class const FdcNutrient({
  /// The USDA nutrient number, such as "203" for protein.
  required final String number,

  /// USDA's name, such as "Protein".
  required final String name,

  /// USDA's unit name, such as "G", "MG", "UG", or "KCAL".
  required final String unitName,
});
