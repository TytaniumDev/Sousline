import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sousvite/features/recipe/application/recipe_data.dart';
import 'package:sousvite/shared/async/combine_async.dart';

part 'recipe_outline.freezed.dart';
part 'recipe_outline.g.dart';

// The shape of a recipe: which sections it has, in order, and which lines
// or steps are in each. Only ids, so a list widget built from an outline
// rebuilds when items are added, removed, or moved, and not when one item's
// text changes. Each item widget watches its own item by id.

/// Ingredient lines grouped by section, in display order.
@freezed
abstract class IngredientOutline with _$IngredientOutline {
  const factory({required List<IngredientGroup> groups}) = _IngredientOutline;
}

/// One ingredient section and its lines. [sectionId] is null for lines
/// that are not in a section, which come first.
@freezed
abstract class IngredientGroup with _$IngredientGroup {
  const factory({
    required IngredientSectionId? sectionId,
    required List<IngredientLineId> lineIds,
  }) = _IngredientGroup;
}

/// Steps grouped by section, in the order they are cooked.
@freezed
abstract class StepOutline with _$StepOutline {
  const factory({required List<StepGroup> groups}) = _StepOutline;
}

/// Flattens a [StepOutline] for cooking mode.
extension StepOutlineSteps on StepOutline {
  /// Every step in cooking order, with its section.
  List<({StepSectionId? sectionId, RecipeStepId stepId})> get steps => [
    for (final group in groups)
      for (final stepId in group.stepIds)
        (sectionId: group.sectionId, stepId: stepId),
  ];
}

/// One step section and its steps. [sectionId] is null for steps that are
/// not in a section, which come first.
@freezed
abstract class StepGroup with _$StepGroup {
  const factory({
    required StepSectionId? sectionId,
    required List<RecipeStepId> stepIds,
  }) = _StepGroup;
}

/// The recipe's ingredient lines grouped by section.
@riverpod
AsyncValue<IngredientOutline> ingredientOutline(Ref ref, RecipeId recipeId) =>
    combineAsync2(
      ref.watch(ingredientSectionsProvider(recipeId)),
      ref.watch(ingredientLinesProvider(recipeId)),
      (sections, lines) => IngredientOutline(
        groups: groupBySection(
          sectionIds: [for (final s in sections) s.id],
          items: lines,
          sectionOf: (line) => line.sectionId,
          idOf: (line) => line.id,
        ).map((g) => IngredientGroup(sectionId: g.$1, lineIds: g.$2)).toList(),
      ),
    );

/// The recipe's steps grouped by section, in cooking order.
@riverpod
AsyncValue<StepOutline> stepOutline(Ref ref, RecipeId recipeId) =>
    combineAsync2(
      ref.watch(stepSectionsProvider(recipeId)),
      ref.watch(recipeStepsProvider(recipeId)),
      (sections, steps) => StepOutline(
        groups: groupBySection(
          sectionIds: [for (final s in sections) s.id],
          items: steps,
          sectionOf: (step) => step.sectionId,
          idOf: (step) => step.id,
        ).map((g) => StepGroup(sectionId: g.$1, stepIds: g.$2)).toList(),
      ),
    );

/// Groups [items] (already in sort order) under [sectionIds] (also in sort
/// order).
///
/// Items with no section, or whose section does not exist (sync can apply
/// an item before its section), form a leading group with a null section,
/// left out when empty. Every section gets a group, even an empty one.
@visibleForTesting
List<(S?, List<I>)> groupBySection<S, T, I>({
  required List<S> sectionIds,
  required List<T> items,
  required S? Function(T item) sectionOf,
  required I Function(T item) idOf,
}) {
  final bySection = {for (final id in sectionIds) id: <I>[]};
  final loose = <I>[];
  for (final item in items) {
    (bySection[sectionOf(item)] ?? loose).add(idOf(item));
  }
  return [
    if (loose.isNotEmpty) (null, loose),
    for (final id in sectionIds) (id, bySection[id]!),
  ];
}
