import 'dart:async';

import 'package:collection/collection.dart';
import 'package:domain/domain.dart';

/// An in-memory [RecipeRepository] for tests.
///
/// Like the real one, every watch stream emits the current value first and
/// then only when its data really changes, so tests can check that a change
/// rebuilds only the widgets that show it.
class FakeRecipeRepository() implements RecipeRepository {
  final _recipes = <RecipeId, Recipe>{};
  final _ingredientSections = <IngredientSectionId, IngredientSection>{};
  final _lines = <IngredientLineId, IngredientLine>{};
  final _stepSections = <StepSectionId, StepSection>{};
  final _steps = <RecipeStepId, RecipeStep>{};
  final _changes = StreamController<void>.broadcast(sync: true);

  /// Every save and delete, in order, for tests that check writes.
  final List<Object> writes = [];

  /// Adds a whole recipe at once, without recording [writes].
  void seed({
    required Recipe recipe,
    List<IngredientSection> ingredientSections = const [],
    List<IngredientLine> lines = const [],
    List<StepSection> stepSections = const [],
    List<RecipeStep> steps = const [],
  }) {
    _recipes[recipe.id] = recipe;
    for (final s in ingredientSections) {
      _ingredientSections[s.id] = s;
    }
    for (final l in lines) {
      _lines[l.id] = l;
    }
    for (final s in stepSections) {
      _stepSections[s.id] = s;
    }
    for (final s in steps) {
      _steps[s.id] = s;
    }
    _changes.add(null);
  }

  Stream<T> _watch<T>(T Function() read) {
    StreamSubscription<void>? changes;
    late final StreamController<T> controller;
    controller = StreamController<T>(
      onListen: () {
        var last = read();
        controller.add(last);
        changes = _changes.stream.listen((_) {
          final next = read();
          if (!const DeepCollectionEquality().equals(next, last)) {
            last = next;
            controller.add(next);
          }
        });
      },
      onCancel: () => changes?.cancel(),
    );
    return controller.stream;
  }

  List<T> _sorted<T>(
    Iterable<T> items,
    bool Function(T) where,
    SortKey Function(T) key,
  ) => items.where(where).sortedBy<String>((item) => key(item).value);

  Future<void> _write(Object write, void Function() apply) async {
    writes.add(write);
    apply();
    _changes.add(null);
  }

  @override
  Stream<List<RecipeId>> watchRecipeIds() => _watch(
    () => _recipes.values
        .sortedBy((r) => r.createdAt)
        .reversed
        .map((r) => r.id)
        .toList(),
  );

  @override
  Stream<Recipe?> watchRecipe(RecipeId id) => _watch(() => _recipes[id]);

  @override
  Stream<List<IngredientSection>> watchIngredientSections(RecipeId recipeId) =>
      _watch(
        () => _sorted(
          _ingredientSections.values,
          (s) => s.recipeId == recipeId,
          (s) => s.sortKey,
        ),
      );

  @override
  Stream<List<IngredientLine>> watchIngredientLines(RecipeId recipeId) =>
      _watch(
        () => _sorted(
          _lines.values,
          (l) => l.recipeId == recipeId,
          (l) => l.sortKey,
        ),
      );

  @override
  Stream<List<StepSection>> watchStepSections(RecipeId recipeId) => _watch(
    () => _sorted(
      _stepSections.values,
      (s) => s.recipeId == recipeId,
      (s) => s.sortKey,
    ),
  );

  @override
  Stream<List<RecipeStep>> watchSteps(RecipeId recipeId) => _watch(
    () =>
        _sorted(_steps.values, (s) => s.recipeId == recipeId, (s) => s.sortKey),
  );

  @override
  Future<Recipe?> getRecipe(RecipeId id) async => _recipes[id];

  @override
  Future<void> saveRecipe(Recipe recipe) =>
      _write(recipe, () => _recipes[recipe.id] = recipe);

  @override
  Future<void> saveIngredientSection(IngredientSection section) =>
      _write(section, () => _ingredientSections[section.id] = section);

  @override
  Future<void> saveIngredientLine(IngredientLine line) =>
      _write(line, () => _lines[line.id] = line);

  @override
  Future<void> saveStepSection(StepSection section) =>
      _write(section, () => _stepSections[section.id] = section);

  @override
  Future<void> saveStep(RecipeStep step) =>
      _write(step, () => _steps[step.id] = step);

  @override
  Future<void> deleteRecipe(RecipeId id) => _write(('delete', id), () {
    _recipes.remove(id);
    _ingredientSections.removeWhere((_, s) => s.recipeId == id);
    _lines.removeWhere((_, l) => l.recipeId == id);
    _stepSections.removeWhere((_, s) => s.recipeId == id);
    _steps.removeWhere((_, s) => s.recipeId == id);
  });

  @override
  Future<void> deleteIngredientSection(IngredientSectionId id) =>
      _write(('delete', id), () => _ingredientSections.remove(id));

  @override
  Future<void> deleteIngredientLine(IngredientLineId id) =>
      _write(('delete', id), () => _lines.remove(id));

  @override
  Future<void> deleteStepSection(StepSectionId id) =>
      _write(('delete', id), () => _stepSections.remove(id));

  @override
  Future<void> deleteStep(RecipeStepId id) =>
      _write(('delete', id), () => _steps.remove(id));
}
