/// A household portion as it is written to the bundled file, matching the
/// app's `FoodPortion` entity.
final class const UsdaPortion({
  /// The row's id in the release's `food_portion.csv`.
  required final int sourceId,

  /// The amount as an exact fraction, such as 1/3 for "0.33".
  required final int amountNumerator,

  /// Always positive.
  required final int amountDenominator,

  /// The portion's weight in grams.
  required final double gramWeight,

  /// The name of the app's `Unit` value ("cup", "fluidOunce"), or null for
  /// counts such as "1 large".
  required final String? unit,

  /// The release's own wording, such as "1 cup, chopped".
  required final String description,
}) {
  /// The app's `FoodPortionId` for this portion.
  String get id => 'usda-portion:$sourceId';
}
