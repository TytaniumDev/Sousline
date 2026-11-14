import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:sousvite/app/providers/repositories.dart';
import 'package:sousvite/features/recipe/application/recipe_outline.dart';

import '../../../helpers/fakes/fake_recipe_repository.dart';
import '../../../helpers/fakes/recipe_fixtures.dart';

void main() {
  const recipeId = RecipeId('r1');

  group('groupBySection', () {
    List<(String?, String)> group(
      List<String> sections,
      List<(String id, String? section)> items,
    ) => groupBySection<String, (String, String?), String>(
      sectionIds: sections,
      items: items,
      sectionOf: (item) => item.$2,
      idOf: (item) => item.$1,
    ).map((g) => (g.$1, g.$2.join(','))).toList();

    test('puts loose items first, then every section in order', () {
      expect(
        group(
          ['a', 'b', 'c'],
          [('1', 'b'), ('2', null), ('3', 'a'), ('4', 'b')],
        ),
        [(null, '2'), ('a', '3'), ('b', '1,4'), ('c', '')],
      );
    });

    test('treats an item whose section is missing as loose', () {
      expect(group(['a'], [('1', 'gone')]), [(null, '1'), ('a', '')]);
    });

    test('leaves out the loose group when it is empty', () {
      expect(group(['a'], [('1', 'a')]), [('a', '1')]);
    });
  });

  group('outlines', () {
    late FakeRecipeRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = FakeRecipeRepository()
        ..seed(
          recipe: RecipeFixtures.recipe(),
          ingredientSections: [RecipeFixtures.ingredientSection('is1')],
          lines: [
            RecipeFixtures.line('l1', sortKey: 'a'),
            RecipeFixtures.line('l2', sectionId: 'is1', sortKey: 'b'),
          ],
          stepSections: [
            RecipeFixtures.stepSection('prep', sortKey: 'a'),
            RecipeFixtures.stepSection('cook', sortKey: 'b'),
          ],
          steps: [
            RecipeFixtures.step('s1', sectionId: 'cook'),
            RecipeFixtures.step('s2', sectionId: 'prep'),
            RecipeFixtures.step('s3', sectionId: 'cook'),
          ],
        );
      container = ProviderContainer.test(
        overrides: [recipeRepositoryProvider.overrideWithValue(repository)],
      );
    });

    Future<T> settle<T>(ProviderListenable<AsyncValue<T>> provider) async {
      container.listen(provider, (_, _) {});
      for (var i = 0; i < 10 && container.read(provider).isLoading; i++) {
        await Future<void>.delayed(Duration.zero);
      }
      return container.read(provider).requireValue;
    }

    test('groups ingredient lines by section', () async {
      expect(
        await settle(ingredientOutlineProvider(recipeId)),
        const IngredientOutline(
          groups: [
            IngredientGroup(sectionId: null, lineIds: [IngredientLineId('l1')]),
            IngredientGroup(
              sectionId: IngredientSectionId('is1'),
              lineIds: [IngredientLineId('l2')],
            ),
          ],
        ),
      );
    });

    test('orders steps by section for cooking', () async {
      final outline = await settle(stepOutlineProvider(recipeId));
      expect(outline.steps, [
        (
          sectionId: const StepSectionId('prep'),
          stepId: const RecipeStepId('s2'),
        ),
        (
          sectionId: const StepSectionId('cook'),
          stepId: const RecipeStepId('s1'),
        ),
        (
          sectionId: const StepSectionId('cook'),
          stepId: const RecipeStepId('s3'),
        ),
      ]);
    });

    test('does not notify when only an item text changes', () async {
      await settle(stepOutlineProvider(recipeId));
      var notifications = 0;
      container.listen(
        stepOutlineProvider(recipeId),
        (_, _) => notifications++,
      );

      await repository.saveStep(
        RecipeFixtures.step('s1', sectionId: 'cook', text: 'Changed'),
      );
      await container.pump();
      expect(notifications, 0);

      await repository.saveStep(RecipeFixtures.step('s4'));
      await container.pump();
      expect(notifications, 1);
    });
  });
}
