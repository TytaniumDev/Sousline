import 'package:data/data.dart';
import 'package:drift/native.dart';
import 'package:sync/sync.dart';
import 'package:test/test.dart';

Change _change(String id, Hlc hlc, {String field = 'title'}) => Change(
  id: id,
  entity: 'recipe',
  entityId: 'r1',
  field: field,
  value: id,
  hlc: hlc,
  deviceId: hlc.nodeId,
  spaceId: 'private',
);

void main() {
  late AppDatabase database;

  setUp(() => database = AppDatabase(NativeDatabase.memory()));

  tearDown(() => database.close());

  group(SyncDao, () {
    final early = _change('a', const Hlc(1000, 0, 'phone'));
    final middle = _change('b', const Hlc(1000, 1, 'laptop'));
    final late = _change('c', const Hlc(2000, 0, 'phone'));
    final otherField = _change(
      'd',
      const Hlc(3000, 0, 'phone'),
      field: 'notes',
    );

    Future<void> insert(List<Change> changes) => database.syncDao.insertChanges(
      [for (final change in changes) change.toCompanion()],
    );

    Future<List<Change>> after(String? hlc) async => [
      for (final row in await database.syncDao.changesAfter(hlc))
        row.toChange(),
    ];

    test('lists changes oldest first, after a given HLC', () async {
      await insert([late, otherField, early, middle]);

      expect(await after(null), [early, middle, late, otherField]);
      expect(await after(middle.hlc.pack()), [late, otherField]);
    });

    test('skips a change it already has', () async {
      await insert([early]);
      await insert([early, middle]);

      expect(await after(null), [early, middle]);
    });

    test('finds the current winner of a field', () async {
      await insert([late, early, otherField]);

      final winner = await database.syncDao.latestForField(
        entity: 'recipe',
        entityId: 'r1',
        field: 'title',
      );
      final missing = await database.syncDao.latestForField(
        entity: 'recipe',
        entityId: 'r2',
        field: 'title',
      );

      expect(winner?.toChange(), late);
      expect(missing, isNull);
    });

    test('reports the highest HLC, or null when empty', () async {
      expect(await database.syncDao.latestHlc(), isNull);

      await insert([middle, otherField, early]);

      expect(await database.syncDao.latestHlc(), otherField.hlc.pack());
    });
  });
}
