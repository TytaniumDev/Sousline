import 'package:sync/sync.dart';
import 'package:test/test.dart';

Change _change({
  required String id,
  required Hlc hlc,
  String field = 'title',
  Object? value = 'Soup',
  String entityId = 'r1',
}) => Change(
  id: id,
  entity: 'recipe',
  entityId: entityId,
  field: field,
  value: value,
  hlc: hlc,
  deviceId: hlc.nodeId,
  spaceId: 'private',
);

void main() {
  const notesPolicy = MergePolicy(
    longTextFields: {(entity: 'recipe', field: 'notes')},
  );

  group('resolve', () {
    final phoneEdit = _change(id: 'p1', hlc: const Hlc(1000, 0, 'phone'));
    final laptopEdit = _change(id: 'l1', hlc: const Hlc(2000, 0, 'laptop'));

    test('the first change for a field wins', () {
      expect(resolve(current: null, incoming: phoneEdit), isA<IncomingWins>());
    });

    test('the higher HLC wins, in either order', () {
      expect(
        resolve(current: phoneEdit, incoming: laptopEdit),
        isA<IncomingWins>(),
      );
      expect(
        resolve(current: laptopEdit, incoming: phoneEdit),
        isA<CurrentWins>(),
      );
    });

    test('the same change twice keeps the current winner', () {
      final decision = resolve(
        current: phoneEdit,
        incoming: phoneEdit,
        policy: notesPolicy,
      );

      expect(decision, isA<CurrentWins>());
      expect((decision as CurrentWins).preserved, isNull);
    });

    test('the change id breaks an exact HLC tie', () {
      const hlc = Hlc(1000, 0, 'phone');
      final a = _change(id: 'a', hlc: hlc);
      final b = _change(id: 'b', hlc: hlc);

      expect(resolve(current: a, incoming: b), isA<IncomingWins>());
      expect(resolve(current: b, incoming: a), isA<CurrentWins>());
    });

    group('losing long text', () {
      final winner = _change(
        id: 'l1',
        field: 'notes',
        value: 'Use less salt.',
        hlc: const Hlc(2000, 0, 'laptop'),
      );

      Change? preserved(Change incoming, {MergePolicy policy = notesPolicy}) =>
          switch (resolve(
            current: winner,
            incoming: incoming,
            policy: policy,
          )) {
            CurrentWins(:final preserved) => preserved,
            IncomingWins() => fail('expected the current change to win'),
          };

      test('is kept when another device made it', () {
        final loser = _change(
          id: 'p1',
          field: 'notes',
          value: 'Add lemon.',
          hlc: const Hlc(1500, 0, 'phone'),
        );

        expect(preserved(loser), loser);
      });

      test('is not kept for fields that are not long text', () {
        final loser = _change(
          id: 'p1',
          field: 'notes',
          value: 'Add lemon.',
          hlc: const Hlc(1500, 0, 'phone'),
        );

        expect(preserved(loser, policy: const MergePolicy()), isNull);
      });

      test('is not kept when the same device wrote both', () {
        final ownEarlierEdit = _change(
          id: 'l0',
          field: 'notes',
          value: 'Draft',
          hlc: const Hlc(1500, 0, 'laptop'),
        );

        expect(preserved(ownEarlierEdit), isNull);
      });

      test('is not kept when it says the same thing', () {
        final sameText = _change(
          id: 'p1',
          field: 'notes',
          value: 'Use less salt.',
          hlc: const Hlc(1500, 0, 'phone'),
        );

        expect(preserved(sameText), isNull);
      });
    });
  });

  group('mergeAll', () {
    test('applies winners, skips losers, and leaves the input alone', () {
      final old = _change(id: 'a', hlc: const Hlc(1000, 0, 'phone'));
      final winners = {old.key: old};
      final newer = _change(id: 'b', hlc: const Hlc(2000, 0, 'laptop'));
      final stale = _change(id: 'c', hlc: const Hlc(500, 0, 'tablet'));
      final other = _change(
        id: 'd',
        field: 'servings',
        value: 4,
        hlc: const Hlc(100, 0, 'tablet'),
      );

      final result = mergeAll(winners, [newer, stale, other]);

      expect(result.applied, [newer, other]);
      expect(result.preserved, isEmpty);
      expect(result.winners, {newer.key: newer, other.key: other});
      expect(winners, {old.key: old});
    });

    test('returns losing long-text edits to keep', () {
      final winner = _change(
        id: 'a',
        field: 'notes',
        value: 'Mine',
        hlc: const Hlc(2000, 0, 'laptop'),
      );
      final loser = _change(
        id: 'b',
        field: 'notes',
        value: 'Theirs',
        hlc: const Hlc(1000, 0, 'phone'),
      );

      final result = mergeAll(
        {winner.key: winner},
        [loser],
        policy: notesPolicy,
      );

      expect(result.applied, isEmpty);
      expect(result.preserved, [loser]);
    });
  });

  group('FieldWinners', () {
    Map<FieldKey, Change> winnersWith(Object? deleted) {
      final change = _change(
        id: 'a',
        field: Change.deletedField,
        value: deleted,
        hlc: const Hlc(1, 0, 'phone'),
      );
      return {change.key: change};
    }

    test('an entity is deleted when its latest tombstone says so', () {
      expect(
        winnersWith(true).isDeleted(entity: 'recipe', entityId: 'r1'),
        isTrue,
      );
      expect(
        winnersWith(false).isDeleted(entity: 'recipe', entityId: 'r1'),
        isFalse,
      );
      expect(
        <FieldKey, Change>{}.isDeleted(entity: 'recipe', entityId: 'r1'),
        isFalse,
      );
    });

    test('a delete beats an older offline edit and loses to a later undo', () {
      final edit = _change(id: 'e', hlc: const Hlc(1000, 0, 'phone'));
      final delete = _change(
        id: 'd',
        field: Change.deletedField,
        value: true,
        hlc: const Hlc(2000, 0, 'laptop'),
      );
      final undo = _change(
        id: 'u',
        field: Change.deletedField,
        value: false,
        hlc: const Hlc(3000, 0, 'phone'),
      );

      final deleted = mergeAll({}, [delete, edit]).winners;
      final restored = mergeAll(deleted, [undo]).winners;

      expect(deleted.isDeleted(entity: 'recipe', entityId: 'r1'), isTrue);
      expect(restored.isDeleted(entity: 'recipe', entityId: 'r1'), isFalse);
    });
  });
}
