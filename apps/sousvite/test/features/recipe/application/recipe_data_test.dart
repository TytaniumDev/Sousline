import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:sousvite/app/providers/repositories.dart';
import 'package:sousvite/features/recipe/application/recipe_data.dart';

import '../../../helpers/fakes/fake_recipe_repository.dart';
import '../../../helpers/fakes/recipe_fixtures.dart';

void main() {
  const recipeId = RecipeId('r1');
  late FakeRecipeRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeRecipeRepository()
      ..seed(
        recipe: RecipeFixtures.recipe(),
        ingredientSections: [
          RecipeFixtures.ingredientSection('is1', name: 'Batter'),
        ],
        lines: [
          RecipeFixtures.line('l1', name: 'oats', sortKey: 'a'),
          RecipeFixtures.line('l2', name: 'milk', sortKey: 'b'),
        ],
        stepSections: [RecipeFixtures.stepSection('ss1', name: 'Prep')],
        steps: [
          RecipeFixtures.step('s1', text: 'Blend the oats', sortKey: 'a'),
          RecipeFixtures.step('s2', text: 'Fry', sortKey: 'b'),
        ],
      );
    container = ProviderContainer.test(
      overrides: [recipeRepositoryProvider.overrideWithValue(repository)],
    );
  });

  /// Listens to [provider] and returns how many times it notified.
  int Function() countNotifications<T>(ProviderListenable<T> provider) {
    var count = 0;
    container.listen(provider, (_, _) => count++);
    return () => count;
  }

  group('recipe data', () {
    test('streams the recipe and its parts', () async {
      container
        ..listen(recipeProvider(recipeId), (_, _) {})
        ..listen(ingredientLinesProvider(recipeId), (_, _) {})
        ..listen(ingredientSectionsProvider(recipeId), (_, _) {})
        ..listen(stepSectionsProvider(recipeId), (_, _) {})
        ..listen(recipeStepsProvider(recipeId), (_, _) {});
      expect(
        (await container.read(recipeProvider(recipeId).future))?.title,
        'Oat pancakes',
      );
      expect(
        await container.read(ingredientLinesProvider(recipeId).future),
        hasLength(2),
      );
      expect(
        await container.read(ingredientSectionsProvider(recipeId).future),
        hasLength(1),
      );
      expect(
        await container.read(stepSectionsProvider(recipeId).future),
        hasLength(1),
      );
      expect(
        await container.read(recipeStepsProvider(recipeId).future),
        hasLength(2),
      );
    });

    test('a line notifies only when that line changes', () async {
      const l1 = IngredientLineId('l1');
      container.listen(ingredientLinesProvider(recipeId), (_, _) {});
      await container.read(ingredientLinesProvider(recipeId).future);
      final notifications = countNotifications(
        ingredientLineProvider(recipeId, l1),
      );
      expect(
        container.read(ingredientLineProvider(recipeId, l1))?.name,
        'oats',
      );

      await repository.saveIngredientLine(
        RecipeFixtures.line('l2', name: 'oat milk', sortKey: 'b'),
      );
      await container.pump();
      expect(notifications(), 0);

      await repository.saveIngredientLine(
        RecipeFixtures.line('l1', name: 'rolled oats', sortKey: 'a'),
      );
      await container.pump();
      expect(notifications(), 1);
      expect(
        container.read(ingredientLineProvider(recipeId, l1))?.name,
        'rolled oats',
      );
    });

    test('a step notifies only when that step changes', () async {
      const s1 = RecipeStepId('s1');
      container.listen(recipeStepsProvider(recipeId), (_, _) {});
      await container.read(recipeStepsProvider(recipeId).future);
      final notifications = countNotifications(
        recipeStepProvider(recipeId, s1),
      );

      await repository.saveStep(
        RecipeFixtures.step('s2', text: 'Fry in butter', sortKey: 'b'),
      );
      await container.pump();
      expect(notifications(), 0);
      expect(
        container.read(recipeStepProvider(recipeId, s1))?.text,
        'Blend the oats',
      );
    });

    test('reads section names by id', () async {
      container
        ..listen(ingredientSectionsProvider(recipeId), (_, _) {})
        ..listen(stepSectionsProvider(recipeId), (_, _) {});
      await container.read(ingredientSectionsProvider(recipeId).future);
      await container.read(stepSectionsProvider(recipeId).future);

      expect(
        container.read(
          ingredientSectionNameProvider(
            recipeId,
            const IngredientSectionId('is1'),
          ),
        ),
        'Batter',
      );
      expect(
        container.read(
          stepSectionNameProvider(recipeId, const StepSectionId('ss1')),
        ),
        'Prep',
      );
      expect(
        container.read(
          stepSectionNameProvider(recipeId, const StepSectionId('missing')),
        ),
        isNull,
      );
    });
  });
}
