// An interface has no code to run; only its empty primary constructor
// would show up, as an uncovered line.
// coverage:ignore-file

import 'package:domain/src/entities/ingredient_line.dart';
import 'package:domain/src/entities/ingredient_section.dart';
import 'package:domain/src/entities/recipe.dart';
import 'package:domain/src/entities/recipe_snapshot.dart';
import 'package:domain/src/entities/recipe_step.dart';
import 'package:domain/src/entities/step_section.dart';
import 'package:domain/src/value_objects/ids.dart';

/// Recipes and their ingredient lines, sections, and steps.
///
/// Watch methods emit only when the watched data really changes, so
/// widgets that watch them rebuild only then (ENGINEERING.md §5).
abstract interface class RecipeRepository() {
  /// Every recipe id, newest first.
  Stream<List<RecipeId>> watchRecipeIds();

  /// One recipe, or null once it is deleted.
  Stream<Recipe?> watchRecipe(RecipeId id);

  Stream<List<IngredientSection>> watchIngredientSections(RecipeId recipeId);

  /// Lines in sort order.
  Stream<List<IngredientLine>> watchIngredientLines(RecipeId recipeId);

  Stream<List<StepSection>> watchStepSections(RecipeId recipeId);

  /// Steps in sort order.
  Stream<List<RecipeStep>> watchSteps(RecipeId recipeId);

  Future<Recipe?> getRecipe(RecipeId id);

  Future<void> saveRecipe(Recipe recipe);

  Future<void> saveIngredientSection(IngredientSection section);

  Future<void> saveIngredientLine(IngredientLine line);

  Future<void> saveStepSection(StepSection section);

  Future<void> saveStep(RecipeStep step);

  /// Saves a recipe with all of its parts in one transaction, such as a
  /// recipe that was just imported (PRD 7.2).
  Future<void> saveSnapshot(RecipeSnapshot snapshot);

  /// Deletes the recipe with its lines, sections, and steps.
  Future<void> deleteRecipe(RecipeId id);

  Future<void> deleteIngredientSection(IngredientSectionId id);

  Future<void> deleteIngredientLine(IngredientLineId id);

  Future<void> deleteStepSection(StepSectionId id);

  Future<void> deleteStep(RecipeStepId id);
}
