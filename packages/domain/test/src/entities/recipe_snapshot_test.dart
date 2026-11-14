import 'package:domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group(RecipeSnapshot, () {
    final recipe = Recipe(
      id: const RecipeId('r1'),
      title: 'Oatmeal',
      servings: Quantity(2),
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );

    test('starts with no parts', () {
      final snapshot = RecipeSnapshot(recipe: recipe);

      expect(snapshot.ingredientSections, isEmpty);
      expect(snapshot.ingredientLines, isEmpty);
      expect(snapshot.stepSections, isEmpty);
      expect(snapshot.steps, isEmpty);
    });

    test('compares by value, including its lists', () {
      const line = IngredientLine(
        id: IngredientLineId('l1'),
        recipeId: RecipeId('r1'),
        rawText: '1 cup oats',
        sortKey: SortKey('a'),
      );

      expect(
        RecipeSnapshot(recipe: recipe, ingredientLines: [line]),
        RecipeSnapshot(recipe: recipe, ingredientLines: [line]),
      );
    });
  });
}
