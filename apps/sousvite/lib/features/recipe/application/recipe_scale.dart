import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sousvite/features/recipe/application/recipe_data.dart';

part 'recipe_scale.g.dart';

/// How much this recipe is scaled for cooking: 2 is a double batch
/// (PRD 7.6). Shared by the recipe page and cooking mode, so amounts in the
/// steps follow the scaling chosen on the page.
///
/// This is not the serving size that per-serving nutrition divides by;
/// that is remembered in `UserRecipePrefs` (PRD 7.4). The scale lasts while
/// the app runs.
@Riverpod(keepAlive: true)
class RecipeScale() extends _$RecipeScale {
  @override
  Quantity build(RecipeId recipeId) => Quantity.one;

  /// Scales by a multiplier, such as 2 for a double batch. Ignores zero
  /// and negative values.
  void scaleBy(Quantity factor) {
    if (factor > Quantity.zero) state = factor;
  }

  /// Scales so the batch makes [servings]. Does nothing until the recipe
  /// has loaded, or when it has no positive servings to scale from.
  void scaleToServings(Quantity servings) {
    final base = ref.read(recipeProvider(recipeId)).value?.servings;
    if (base == null || base <= Quantity.zero) return;
    scaleBy(servings / base);
  }

  /// Back to the recipe as written.
  void reset() => state = Quantity.one;
}

/// How many servings the batch makes at the current scale. Null until the
/// recipe loads.
@riverpod
Quantity? scaledServings(Ref ref, RecipeId recipeId) {
  final base = ref.watch(
    recipeProvider(recipeId).select((recipe) => recipe.value?.servings),
  );
  if (base == null) return null;
  return base * ref.watch(recipeScaleProvider(recipeId));
}

/// An amount as shown: quantity (and the top of a range) with its unit.
typedef ScaledAmount = ({
  Quantity? quantity,
  Quantity? quantityMax,
  Unit? unit,
});

/// One line's amount at the current scale. Null while loading or when the
/// line is gone.
///
/// Unit conversion and rounding to amounts people can measure come from
/// `FND-1` and are applied here once it lands.
@riverpod
ScaledAmount? scaledLineAmount(
  Ref ref,
  RecipeId recipeId,
  IngredientLineId lineId,
) {
  final amount = ref.watch(
    ingredientLineProvider(recipeId, lineId).select(
      (line) => line == null
          ? null
          : (
              quantity: line.quantity,
              quantityMax: line.quantityMax,
              unit: line.unit,
            ),
    ),
  );
  if (amount == null) return null;
  final factor = ref.watch(recipeScaleProvider(recipeId));
  return (
    quantity: amount.quantity == null ? null : amount.quantity! * factor,
    quantityMax: amount.quantityMax == null
        ? null
        : amount.quantityMax! * factor,
    unit: amount.unit,
  );
}
