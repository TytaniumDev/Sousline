import 'package:collection/collection.dart';
import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sousvite/app/providers/repositories.dart';

part 'recipe_data.g.dart';

// Streams of one recipe's data, straight from the repository. Repository
// watch streams emit only when their data really changes, so these notify
// only then. Widgets narrow them further with `select` or the derived
// providers below (ENGINEERING.md §5).

/// One recipe, or null once it is deleted.
@riverpod
Stream<Recipe?> recipe(Ref ref, RecipeId recipeId) =>
    ref.watch(recipeRepositoryProvider).watchRecipe(recipeId);

/// The recipe's ingredient sections, in sort order.
@riverpod
Stream<List<IngredientSection>> ingredientSections(
  Ref ref,
  RecipeId recipeId,
) => ref.watch(recipeRepositoryProvider).watchIngredientSections(recipeId);

/// The recipe's ingredient lines, in sort order.
@riverpod
Stream<List<IngredientLine>> ingredientLines(Ref ref, RecipeId recipeId) =>
    ref.watch(recipeRepositoryProvider).watchIngredientLines(recipeId);

/// The recipe's step sections, in sort order.
@riverpod
Stream<List<StepSection>> stepSections(Ref ref, RecipeId recipeId) =>
    ref.watch(recipeRepositoryProvider).watchStepSections(recipeId);

/// The recipe's steps, in sort order.
@riverpod
Stream<List<RecipeStep>> recipeSteps(Ref ref, RecipeId recipeId) =>
    ref.watch(recipeRepositoryProvider).watchSteps(recipeId);

/// One ingredient line. Notifies only when this line changes, not when a
/// sibling does. Null while the lines load or once the line is deleted.
@riverpod
IngredientLine? ingredientLine(
  Ref ref,
  RecipeId recipeId,
  IngredientLineId lineId,
) => ref.watch(
  ingredientLinesProvider(recipeId)
      .select((lines) => lines.value?.firstWhereOrNull((l) => l.id == lineId)),
);

/// One step. Notifies only when this step changes.
@riverpod
RecipeStep? recipeStep(Ref ref, RecipeId recipeId, RecipeStepId stepId) =>
    ref.watch(
      recipeStepsProvider(
        recipeId,
      ).select((steps) => steps.value?.firstWhereOrNull((s) => s.id == stepId)),
    );

/// The name of one ingredient section.
@riverpod
String? ingredientSectionName(
  Ref ref,
  RecipeId recipeId,
  IngredientSectionId sectionId,
) => ref.watch(
  ingredientSectionsProvider(recipeId).select(
    (sections) =>
        sections.value?.firstWhereOrNull((s) => s.id == sectionId)?.name,
  ),
);

/// The name of one step section.
@riverpod
String? stepSectionName(Ref ref, RecipeId recipeId, StepSectionId sectionId) =>
    ref.watch(
      stepSectionsProvider(recipeId).select(
        (sections) =>
            sections.value?.firstWhereOrNull((s) => s.id == sectionId)?.name,
      ),
    );
