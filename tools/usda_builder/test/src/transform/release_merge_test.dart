import 'package:test/test.dart';
import 'package:usda_builder/src/model/usda_food.dart';
import 'package:usda_builder/src/model/usda_portion.dart';
import 'package:usda_builder/src/transform/release_merge.dart';

void main() {
  UsdaPortion cup(int sourceId) => UsdaPortion(
    sourceId: sourceId,
    amountNumerator: 1,
    amountDenominator: 1,
    gramWeight: 152,
    unit: 'cup',
    description: '1 cup',
  );

  UsdaFood food(
    int fdcId,
    String name, {
    int nutrients = 1,
    List<UsdaPortion> portions = const [],
  }) => UsdaFood(
    fdcId: fdcId,
    name: name,
    nutrients: {for (var i = 0; i < nutrients; i++) '$i': 1},
    portions: portions,
  );

  group('mergeReleases', () {
    test('keeps foods with unique names, ordered by FDC id', () {
      final merged = mergeReleases(
        foundation: [food(300, 'Broccoli, raw')],
        srLegacy: [food(200, 'Egg, whole, raw, fresh')],
      );

      expect(merged.map((f) => f.fdcId), [200, 300]);
    });

    test('prefers the Foundation food over SR Legacy', () {
      final merged = mergeReleases(
        foundation: [food(300, 'Broccoli, raw')],
        srLegacy: [food(200, 'broccoli, RAW ', nutrients: 30)],
      );

      expect(merged.map((f) => f.fdcId), [300]);
    });

    test('prefers more nutrients, then the newest food, within a release', () {
      final merged = mergeReleases(
        foundation: [
          food(100, 'Strawberries, raw', nutrients: 2),
          food(101, 'Strawberries, raw', nutrients: 3),
          food(102, 'Strawberries, raw', nutrients: 3),
          food(103, 'Strawberries, raw'),
        ],
        srLegacy: [],
      );

      expect(merged.map((f) => f.fdcId), [102]);
    });

    test('borrows portions from the best same-name food that has some', () {
      final merged = mergeReleases(
        foundation: [
          food(100, 'Strawberries, raw', nutrients: 3),
          food(101, 'Strawberries, raw', portions: [cup(1)]),
        ],
        srLegacy: [
          food(200, 'Strawberries, raw', portions: [cup(2)]),
        ],
      ).single;

      expect(merged.fdcId, 100);
      expect(merged.nutrients, hasLength(3));
      expect(merged.portions.single.sourceId, 1);
    });

    test('keeps its own portions when it has some', () {
      final merged = mergeReleases(
        foundation: [
          food(100, 'Strawberries, raw', portions: [cup(1)]),
        ],
        srLegacy: [
          food(200, 'Strawberries, raw', portions: [cup(2)]),
        ],
      ).single;

      expect(merged.portions.single.sourceId, 1);
    });

    test('keeps a food without portions when no twin has any', () {
      final merged = mergeReleases(
        foundation: [food(100, 'Salt, table, iodized')],
        srLegacy: [food(200, 'Salt, table, iodized')],
      ).single;

      expect(merged.fdcId, 100);
      expect(merged.portions, isEmpty);
    });
  });
}
