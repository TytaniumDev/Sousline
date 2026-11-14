import 'package:sync/sync.dart';
import 'package:test/test.dart';

void main() {
  group(Hlc, () {
    test('orders by millis, then counter, then node', () {
      const early = Hlc(1000, 5, 'b');
      const later = Hlc(1001, 0, 'a');
      const sameMillisLaterCounter = Hlc(1000, 6, 'a');
      const sameAllButNode = Hlc(1000, 5, 'c');

      expect(early < later, isTrue);
      expect(early < sameMillisLaterCounter, isTrue);
      expect(early < sameAllButNode, isTrue);
      expect(later > early, isTrue);
      expect(early.compareTo(const Hlc(1000, 5, 'b')), 0);
    });

    test('packs to a string with the same order', () {
      final timestamps = [
        const Hlc(1731600000000, 2, 'phone'),
        const Hlc(999, 0, 'z'),
        const Hlc(1731600000000, 10, 'a'),
        const Hlc(1731600000000, 2, 'laptop'),
      ];

      final byValue = [...timestamps]..sort();
      final byString = [...timestamps]
        ..sort((a, b) => a.pack().compareTo(b.pack()));

      expect(byString, byValue);
    });

    test(
      'round-trips through pack and parse, even with dashes in the node',
      () {
        const hlc = Hlc(1731600000000, 42, 'device-1f2e');

        expect(hlc.pack(), '001731600000000-00042-device-1f2e');
        expect(Hlc.parse(hlc.pack()), hlc);
        expect(hlc.toString(), hlc.pack());
      },
    );

    test('throws on text that is not a packed HLC', () {
      expect(() => Hlc.parse('2026-11-14'), throwsFormatException);
    });

    test('has value equality', () {
      expect(const Hlc(1, 2, 'a'), const Hlc(1, 2, 'a'));
      expect(const Hlc(1, 2, 'a').hashCode, const Hlc(1, 2, 'a').hashCode);
      expect(const Hlc(1, 2, 'a'), isNot(const Hlc(1, 2, 'b')));
    });
  });

  group(HybridLogicalClock, () {
    late int now;
    late HybridLogicalClock clock;

    setUp(() {
      now = 1000;
      clock = HybridLogicalClock('phone', wallClock: () => now);
    });

    test('uses the wall clock when it has moved on', () {
      expect(clock.tick(), const Hlc(1000, 0, 'phone'));
      now = 1005;
      expect(clock.tick(), const Hlc(1005, 0, 'phone'));
      expect(clock.latest, const Hlc(1005, 0, 'phone'));
    });

    test('counts up within the same millisecond', () {
      clock.tick();

      expect(clock.tick(), const Hlc(1000, 1, 'phone'));
      expect(clock.tick(), const Hlc(1000, 2, 'phone'));
    });

    test('never goes backwards when the wall clock does', () {
      final first = clock.tick();
      now = 500;

      expect(clock.tick() > first, isTrue);
    });

    test('ticks past a timestamp received from the future', () {
      const remote = Hlc(5000, 3, 'laptop');
      clock.receive(remote);

      final next = clock.tick();

      expect(next > remote, isTrue);
      expect(next, const Hlc(5000, 4, 'phone'));
    });

    test('ignores a received timestamp that is older', () {
      now = 9000;
      final latest = clock.tick();
      clock.receive(const Hlc(10, 0, 'laptop'));

      expect(clock.latest, latest);
    });

    test('borrows a millisecond when the counter is full', () {
      clock.receive(const Hlc(1000, Hlc.maxCounter, 'laptop'));

      expect(clock.tick(), const Hlc(1001, 0, 'phone'));
    });
  });
}
