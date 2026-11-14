import 'package:domain/domain.dart';

/// Small builders for recipe entities in tests, with sensible defaults so a
/// test names only the fields it cares about.
abstract final class RecipeFixtures() {
  static final createdAt = DateTime.utc(2026, 11, 14);

  static Recipe recipe({
    String id = 'r1',
    String title = 'Oat pancakes',
    Quantity servings = Quantity.one,
    DateTime? createdAt,
  }) => Recipe(
    id: RecipeId(id),
    title: title,
    servings: servings,
    createdAt: createdAt ?? RecipeFixtures.createdAt,
    updatedAt: createdAt ?? RecipeFixtures.createdAt,
  );

  static IngredientLine line(
    String id, {
    String recipeId = 'r1',
    String? sectionId,
    String? sortKey,
    Quantity? quantity,
    Quantity? quantityMax,
    Unit? unit,
    String? name,
    String? rawText,
  }) => IngredientLine(
    id: IngredientLineId(id),
    recipeId: RecipeId(recipeId),
    rawText: rawText ?? name ?? id,
    sortKey: SortKey(sortKey ?? id),
    sectionId: sectionId == null ? null : IngredientSectionId(sectionId),
    quantity: quantity,
    quantityMax: quantityMax,
    unit: unit,
    name: name,
  );

  static IngredientSection ingredientSection(
    String id, {
    String recipeId = 'r1',
    String name = 'Section',
    String? sortKey,
  }) => IngredientSection(
    id: IngredientSectionId(id),
    recipeId: RecipeId(recipeId),
    name: name,
    sortKey: SortKey(sortKey ?? id),
  );

  static StepSection stepSection(
    String id, {
    String recipeId = 'r1',
    String name = 'Section',
    String? sortKey,
  }) => StepSection(
    id: StepSectionId(id),
    recipeId: RecipeId(recipeId),
    name: name,
    sortKey: SortKey(sortKey ?? id),
  );

  static RecipeStep step(
    String id, {
    String recipeId = 'r1',
    String? sectionId,
    String? sortKey,
    String? text,
  }) => RecipeStep(
    id: RecipeStepId(id),
    recipeId: RecipeId(recipeId),
    text: text ?? 'Step $id',
    sortKey: SortKey(sortKey ?? id),
    sectionId: sectionId == null ? null : StepSectionId(sectionId),
  );
}
