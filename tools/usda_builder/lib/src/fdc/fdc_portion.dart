/// A household portion from a FoodData Central `food_portion.csv` row.
final class const FdcPortion({
  /// The row's id in `food_portion.csv`.
  required final int id,

  /// The amount as written in the release, such as "1" or "0.33".
  required final String amount,

  /// The measure unit's name ("cup"), or null when the release marks it
  /// undetermined. SR Legacy always leaves it undetermined and puts the
  /// unit in [modifier] instead.
  required final String? measureUnit,

  /// Extra wording, such as "shredded".
  required final String portionDescription,

  /// Extra wording, such as "cup, chopped" or "large".
  required final String modifier,

  /// The portion's weight in grams.
  required final double gramWeight,
});
