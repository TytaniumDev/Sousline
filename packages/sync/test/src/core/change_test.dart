import 'package:sync/sync.dart';
import 'package:test/test.dart';

void main() {
  group(Change, () {
    const change = Change(
      id: 'c1',
      entity: 'recipe',
      entityId: 'r1',
      field: 'tags',
      value: {
        'list': ['a', 'b'],
      },
      hlc: Hlc(1000, 0, 'phone'),
      deviceId: 'phone',
      spaceId: 'private',
    );

    test('round-trips through JSON', () {
      expect(Change.fromJson(change.toJson()), change);
      expect(change.toJson()['hlc'], '000000000001000-00000-phone');
    });

    test('compares JSON values deeply', () {
      final copy = Change.fromJson({
        ...change.toJson(),
        'value': const {
          'list': ['a', 'b'],
        },
      });

      expect(copy, change);
      expect(copy.hashCode, change.hashCode);
      expect(
        Change.fromJson({...change.toJson(), 'value': 'x'}),
        isNot(change),
      );
    });

    test('names its field', () {
      expect(change.key, (entity: 'recipe', entityId: 'r1', field: 'tags'));
    });

    test('is a tombstone only when it sets the deleted field to true', () {
      Change deleted({required Object? value}) => Change.fromJson({
        ...change.toJson(),
        'field': Change.deletedField,
        'value': value,
      });

      expect(deleted(value: true).isTombstone, isTrue);
      expect(deleted(value: false).isTombstone, isFalse);
      expect(change.isTombstone, isFalse);
    });

    test('prints a debug form', () {
      expect(change.toString(), contains('recipe/r1.tags'));
    });
  });
}
