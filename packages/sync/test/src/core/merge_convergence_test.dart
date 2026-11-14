import 'dart:math';

import 'package:sync/sync.dart';
import 'package:test/test.dart';

/// Randomized multi-device tests: whatever order changes travel in, with
/// skewed clocks, duplicates, and partial syncs, every replica ends with
/// the same winners (BUILD_PLAN SYN-1).
void main() {
  const policy = MergePolicy(
    longTextFields: {(entity: 'recipe', field: 'notes')},
  );

  for (var seed = 0; seed < 25; seed++) {
    test('replicas converge (seed $seed)', () {
      final random = Random(seed);
      final world = _World(random, deviceCount: 2 + random.nextInt(4));

      for (var step = 0; step < 400; step++) {
        final device = world.pickDevice();
        if (random.nextBool()) {
          final change = device.write(random);
          final result = mergeAll(device.winners, [change], policy: policy);
          // A local edit always wins on its own device: its clock is past
          // everything the device has seen.
          expect(result.applied, [change]);
          device.winners = result.winners;
        } else {
          world.sync(from: world.pickDevice(), to: device, policy: policy);
        }
      }
      world.syncEveryone(policy);

      final expected = world.highestChangePerField();
      for (final device in world.devices) {
        expect(device.winners, expected, reason: device.id);
      }
    });
  }

  test('a concurrent notes edit that loses is kept somewhere', () {
    var now = 1000;
    final phone = _Device('phone', () => now);
    final laptop = _Device('laptop', () => now);

    final phoneEdit = phone.writeField('notes', 'Add lemon.');
    now += 10;
    final laptopEdit = laptop.writeField('notes', 'Use less salt.');
    phone.winners = mergeAll(phone.winners, [phoneEdit]).winners;
    laptop.winners = mergeAll(laptop.winners, [laptopEdit]).winners;

    final onPhone = mergeAll(phone.winners, [laptopEdit], policy: policy);
    final onLaptop = mergeAll(laptop.winners, [phoneEdit], policy: policy);

    expect(onPhone.winners, onLaptop.winners);
    expect([...onPhone.preserved, ...onLaptop.preserved], [phoneEdit]);
  });
}

const List<String> _fields = [
  'title',
  'notes',
  'servings',
  Change.deletedField,
];
const _entityIds = ['r1', 'r2', 'r3'];

final class _Device(final String id, int Function() wallClock) {
  final HybridLogicalClock clock = HybridLogicalClock(id, wallClock: wallClock);
  final known = <Change>{};
  Map<FieldKey, Change> winners = <FieldKey, Change>{};
  var _sequence = 0;

  Change write(Random random) => writeField(
    _fields[random.nextInt(_fields.length)],
    random.nextInt(5),
    entityId: _entityIds[random.nextInt(_entityIds.length)],
  );

  Change writeField(String field, Object? value, {String entityId = 'r1'}) {
    final change = Change(
      id: '$id-${_sequence++}',
      entity: 'recipe',
      entityId: entityId,
      field: field,
      value: field == Change.deletedField
          ? value is int && value.isEven
          : value,
      hlc: clock.tick(),
      deviceId: id,
      spaceId: 'private',
    );
    known.add(change);
    return change;
  }

  void receive(List<Change> changes, MergePolicy policy) {
    for (final change in changes) {
      clock.receive(change.hlc);
    }
    winners = mergeAll(winners, changes, policy: policy).winners;
    known.addAll(changes);
  }
}

final class _World(final Random random, {required final int deviceCount}) {
  late final List<_Device> devices = [
    for (var i = 0; i < deviceCount; i++)
      _Device('device$i', _skewedClock(random.nextInt(120000) - 60000)),
  ];
  var _now = 1731600000000;

  _Device pickDevice() => devices[random.nextInt(devices.length)];

  /// A wall clock that is [skew] ms off and moves on a little every read.
  int Function() _skewedClock(int skew) => () {
    _now += random.nextInt(3);
    return _now + skew;
  };

  /// Sends some of what [from] knows to [to], shuffled, with duplicates.
  void sync({
    required _Device from,
    required _Device to,
    required MergePolicy policy,
  }) {
    final batch = from.known.where((_) => random.nextBool()).toList();
    batch
      ..addAll(batch.take(random.nextInt(batch.length + 1)).toList())
      ..shuffle(random);
    to.receive(batch, policy);
  }

  void syncEveryone(MergePolicy policy) {
    final everything = {for (final device in devices) ...device.known};
    for (final device in devices) {
      device.receive(everything.toList()..shuffle(random), policy);
    }
  }

  /// The change with the highest HLC for every field ever written.
  Map<FieldKey, Change> highestChangePerField() {
    final highest = <FieldKey, Change>{};
    for (final change in {for (final device in devices) ...device.known}) {
      final current = highest[change.key];
      if (current == null || change.hlc > current.hlc) {
        highest[change.key] = change;
      }
    }
    return highest;
  }
}
