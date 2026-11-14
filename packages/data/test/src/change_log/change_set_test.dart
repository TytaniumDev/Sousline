import 'package:data/data.dart';
import 'package:sync/sync.dart';
import 'package:test/test.dart';

void main() {
  group(ChangeSet, () {
    test('records one pending change per field, in order', () {
      final changes = ChangeSet()
        ..set('recipe', 'r1', {'title': 'Soup', 'notes': null})
        ..set('ingredient_line', 'l1', {'name': 'salt'}, spaceId: 's1');

      expect(changes.pending, [
        (
          entity: 'recipe',
          entityId: 'r1',
          field: 'title',
          value: 'Soup',
          spaceId: null,
        ),
        (
          entity: 'recipe',
          entityId: 'r1',
          field: 'notes',
          value: null,
          spaceId: null,
        ),
        (
          entity: 'ingredient_line',
          entityId: 'l1',
          field: 'name',
          value: 'salt',
          spaceId: 's1',
        ),
      ]);
    });

    test('records a delete as the sync tombstone field', () {
      final changes = ChangeSet()..delete('recipe', 'r1');

      expect(changes.pending.single.field, Change.deletedField);
      expect(changes.pending.single.value, isTrue);
    });

    test('does not let callers edit what was recorded', () {
      final changes = ChangeSet()..set('recipe', 'r1', {'title': 'Soup'});

      expect(changes.pending.clear, throwsUnsupportedError);
    });
  });
}
