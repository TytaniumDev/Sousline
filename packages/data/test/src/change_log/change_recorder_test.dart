import 'package:data/data.dart';
import 'package:drift/native.dart';
import 'package:sync/sync.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase database;
  late int now;
  late int nextId;
  late ChangeRecorder recorder;

  ChangeRecorder recorderFor(String deviceId) => ChangeRecorder(
    database,
    clock: HybridLogicalClock(deviceId, wallClock: () => now),
    spaceId: 'private',
    newId: () => 'change-${nextId++}',
  );

  Future<List<Change>> recorded() async => [
    for (final row in await database.syncDao.changesAfter(null)) row.toChange(),
  ];

  Future<void> insertRecipe(String id, String title) => database
      .into(database.recipes)
      .insert(
        RecipesCompanion.insert(
          id: id,
          title: title,
          servingsNumerator: 2,
          servingsDenominator: 1,
          createdAt: DateTime.utc(2026, 11, 14),
          updatedAt: DateTime.utc(2026, 11, 14),
        ),
      );

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    now = 1000;
    nextId = 0;
    recorder = recorderFor('phone');
  });

  tearDown(() => database.close());

  group(ChangeRecorder, () {
    test('stores one change per field with the write', () async {
      final result = await recorder.write((changes) async {
        await insertRecipe('r1', 'Soup');
        changes.set('recipe', 'r1', {
          'title': 'Soup',
          'servings': {'n': 2, 'd': 1},
        });
        return 'done';
      });

      expect(result, 'done');
      expect(await database.select(database.recipes).get(), hasLength(1));
      expect(await recorded(), [
        const Change(
          id: 'change-0',
          entity: 'recipe',
          entityId: 'r1',
          field: 'title',
          value: 'Soup',
          hlc: Hlc(1000, 0, 'phone'),
          deviceId: 'phone',
          spaceId: 'private',
        ),
        const Change(
          id: 'change-1',
          entity: 'recipe',
          entityId: 'r1',
          field: 'servings',
          value: {'n': 2, 'd': 1},
          hlc: Hlc(1000, 1, 'phone'),
          deviceId: 'phone',
          spaceId: 'private',
        ),
      ]);
    });

    test('records a delete as a tombstone', () async {
      await recorder.write((changes) async => changes.delete('recipe', 'r1'));

      final [change] = await recorded();

      expect(change.isTombstone, isTrue);
      expect(change.field, Change.deletedField);
    });

    test('uses the space a write names', () async {
      await recorder.write(
        (changes) async =>
            changes.set('recipe', 'r1', {'title': 'Shared'}, spaceId: 's1'),
      );

      final [change] = await recorded();

      expect(change.spaceId, 's1');
    });

    test('keeps neither the write nor its changes when the write fails', () {
      final failing = recorder.write<void>((changes) async {
        await insertRecipe('r1', 'Soup');
        changes.set('recipe', 'r1', {'title': 'Soup'});
        throw StateError('disk full');
      });

      return expectLater(failing, throwsStateError).then((_) async {
        expect(await database.select(database.recipes).get(), isEmpty);
        expect(await recorded(), isEmpty);
      });
    });

    test('nested writes all land in the outer transaction', () async {
      await recorder.write((outer) async {
        outer.set('recipe', 'r1', {'title': 'Soup'});
        await recorder.write(
          (inner) async => inner.set('ingredient_line', 'l1', {'name': 'salt'}),
        );
      });

      expect(
        (await recorded()).map((change) => change.entity),
        unorderedEquals(['recipe', 'ingredient_line']),
      );
    });

    test('a write that records nothing stores nothing', () async {
      await recorder.write((_) => insertRecipe('r1', 'Soup'));

      expect(await recorded(), isEmpty);
    });

    test(
      'resumes the clock after a restart with a wall clock behind',
      () async {
        now = 5000;
        await recorder.write(
          (changes) async => changes.set('recipe', 'r1', {'title': 'Soup'}),
        );

        now = 10;
        final restarted = recorderFor('phone');
        await restarted.resumeClock();
        await restarted.write(
          (changes) async => changes.set('recipe', 'r1', {'title': 'Stew'}),
        );

        final [first, second] = await recorded();
        expect(second.hlc > first.hlc, isTrue);
      },
    );

    test('resuming with an empty change log leaves the clock alone', () async {
      await recorder.resumeClock();

      expect(recorder.clock.latest, const Hlc(0, 0, 'phone'));
    });
  });
}
