import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_recipe_repository.dart';
import 'recipe_fixtures.dart';

void main() {
  group(FakeRecipeRepository, () {
    late FakeRecipeRepository repository;

    setUp(() => repository = FakeRecipeRepository());

    test('saves, reads, and deletes a whole recipe', () async {
      const id = RecipeId('r1');
      await repository.saveRecipe(RecipeFixtures.recipe());
      await repository.saveIngredientSection(
        RecipeFixtures.ingredientSection('is1'),
      );
      await repository.saveIngredientLine(RecipeFixtures.line('l1'));
      await repository.saveStepSection(RecipeFixtures.stepSection('ss1'));
      await repository.saveStep(RecipeFixtures.step('s1'));

      expect(await repository.getRecipe(id), isNotNull);
      expect(await repository.watchRecipeIds().first, [id]);
      expect(await repository.watchIngredientSections(id).first, hasLength(1));
      expect(await repository.watchStepSections(id).first, hasLength(1));

      await repository.deleteIngredientSection(
        const IngredientSectionId('is1'),
      );
      await repository.deleteIngredientLine(const IngredientLineId('l1'));
      await repository.deleteStepSection(const StepSectionId('ss1'));
      await repository.deleteStep(const RecipeStepId('s1'));
      expect(await repository.watchIngredientLines(id).first, isEmpty);
      expect(await repository.watchSteps(id).first, isEmpty);

      await repository.deleteRecipe(id);
      expect(await repository.getRecipe(id), isNull);
      expect(repository.writes, hasLength(10));
    });

    test('lists the newest recipe first', () async {
      repository
        ..seed(recipe: RecipeFixtures.recipe(id: 'old'))
        ..seed(
          recipe: RecipeFixtures.recipe(
            id: 'new',
            createdAt: DateTime.utc(2027),
          ),
        );
      expect(await repository.watchRecipeIds().first, [
        const RecipeId('new'),
        const RecipeId('old'),
      ]);
    });

    test('emits only when the watched data changes', () async {
      repository.seed(recipe: RecipeFixtures.recipe());
      final emitted = <Recipe?>[];
      final subscription = repository
          .watchRecipe(const RecipeId('r1'))
          .listen(emitted.add);
      await pumpEventQueue();

      await repository.saveRecipe(RecipeFixtures.recipe(id: 'other'));
      await pumpEventQueue();
      expect(emitted, hasLength(1));

      await repository.saveRecipe(RecipeFixtures.recipe(title: 'Waffles'));
      await pumpEventQueue();
      expect(emitted.map((r) => r?.title), ['Oat pancakes', 'Waffles']);
      await subscription.cancel();
    });
  });
}
