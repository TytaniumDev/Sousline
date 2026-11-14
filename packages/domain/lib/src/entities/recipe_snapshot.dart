import 'package:domain/src/entities/ingredient_line.dart';
import 'package:domain/src/entities/ingredient_section.dart';
import 'package:domain/src/entities/recipe.dart';
import 'package:domain/src/entities/recipe_step.dart';
import 'package:domain/src/entities/step_section.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_snapshot.freezed.dart';

/// A recipe with all of its parts at one moment: what a past version holds
/// (PRD 7.11) and what an import produces before it is saved (PRD 7.2).
///
/// Lists are in sort order.
@freezed
abstract class RecipeSnapshot with _$RecipeSnapshot {
  const factory({
    required Recipe recipe,
    @Default(<IngredientSection>[]) List<IngredientSection> ingredientSections,
    @Default(<IngredientLine>[]) List<IngredientLine> ingredientLines,
    @Default(<StepSection>[]) List<StepSection> stepSections,
    @Default(<RecipeStep>[]) List<RecipeStep> steps,
  }) = _RecipeSnapshot;
}
