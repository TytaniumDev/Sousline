import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sousvite/app/providers/repositories.dart';
import 'package:sousvite/features/recipe/application/recipe_data.dart';
import 'package:sousvite/features/recipe/application/recipe_scale.dart';

import '../../../helpers/fakes/fake_recipe_repository.dart';
import '../../../helpers/fakes/recipe_fixtures.dart';

void main() {
  const recipeId = RecipeId('r1');
  const lineId = IngredientLineId('l1');
  late ProviderContainer container;

  setUp(() async {
    final repository = FakeRecipeRepository()
      ..seed(
        recipe: RecipeFixtures.recipe(servings: Quantity(4)),
        lines: [
          RecipeFixtures.line(
            'l1',
            quantity: Quantity(3, 4),
            quantityMax: Quantity(1),
            unit: Unit.cup,
          ),
          RecipeFixtures.line('l2', name: 'salt'),
        ],
      );
    container =
        ProviderContainer.test(
            overrides: [recipeRepositoryProvider.overrideWithValue(repository)],
          )
          ..listen(recipeProvider(recipeId), (_, _) {})
          ..listen(ingredientLinesProvider(recipeId), (_, _) {});
    await container.read(recipeProvider(recipeId).future);
    await container.read(ingredientLinesProvider(recipeId).future);
  });

  RecipeScale scale() => container.read(recipeScaleProvider(recipeId).notifier);

  group(RecipeScale, () {
    test('starts at the recipe as written', () {
      expect(container.read(recipeScaleProvider(recipeId)), Quantity.one);
      expect(container.read(scaledServingsProvider(recipeId)), Quantity(4));
    });

    test('scales by a multiplier and ignores non-positive ones', () {
      scale().scaleBy(Quantity(2));
      expect(container.read(scaledServingsProvider(recipeId)), Quantity(8));

      scale()
        ..scaleBy(Quantity.zero)
        ..scaleBy(Quantity(-1));
      expect(container.read(recipeScaleProvider(recipeId)), Quantity(2));

      scale().reset();
      expect(container.read(recipeScaleProvider(recipeId)), Quantity.one);
    });

    test('scales to a number of servings', () {
      scale().scaleToServings(Quantity(6));
      expect(container.read(recipeScaleProvider(recipeId)), Quantity(3, 2));
      expect(container.read(scaledServingsProvider(recipeId)), Quantity(6));
    });

    test('scales line amounts exactly', () {
      scale().scaleToServings(Quantity(12));
      expect(container.read(scaledLineAmountProvider(recipeId, lineId)), (
        quantity: Quantity(9, 4),
        quantityMax: Quantity(3),
        unit: Unit.cup,
      ));
      expect(
        container.read(
          scaledLineAmountProvider(recipeId, const IngredientLineId('l2')),
        ),
        (quantity: null, quantityMax: null, unit: null),
      );
      expect(
        container.read(
          scaledLineAmountProvider(recipeId, const IngredientLineId('gone')),
        ),
        isNull,
      );
    });
  });

  test('scaling to servings waits for the recipe to load', () {
    final empty = ProviderContainer.test(
      overrides: [
        recipeRepositoryProvider.overrideWithValue(FakeRecipeRepository()),
      ],
    );
    empty
        .read(recipeScaleProvider(recipeId).notifier)
        .scaleToServings(Quantity(2));
    expect(empty.read(recipeScaleProvider(recipeId)), Quantity.one);
    expect(empty.read(scaledServingsProvider(recipeId)), isNull);
  });
}
