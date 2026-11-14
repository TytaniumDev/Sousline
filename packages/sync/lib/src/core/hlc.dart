import 'package:meta/meta.dart';

/// A hybrid logical clock timestamp (ENGINEERING.md §8.1).
///
/// Timestamps order every change consistently across devices, even when
/// their wall clocks disagree: by [millis], then [counter], then [nodeId].
/// [pack] encodes one so that string order is the same as this order,
/// which is how the `change_log.hlc` column stores it.
@immutable
final class const Hlc(
  /// Milliseconds since the Unix epoch, from the wall clock or carried
  /// forward from a later timestamp this device has seen.
  final int millis,

  /// Orders timestamps that share [millis].
  final int counter,

  /// The device that made this timestamp. Breaks the last ties.
  final String nodeId,
) implements Comparable<Hlc> {
  /// Reads a timestamp written by [pack].
  ///
  /// Throws a [FormatException] when [packed] is not one.
  factory parse(String packed) {
    final match = _packedPattern.firstMatch(packed);
    if (match == null) throw FormatException('Not a packed HLC', packed);
    return Hlc(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      match.group(3)!,
    );
  }

  /// The largest [counter] a timestamp can hold.
  static const maxCounter = 99999;

  static const _millisDigits = 15;
  static const _counterDigits = 5;
  static final _packedPattern = RegExp(r'^(\d{15})-(\d{5})-(.+)$');

  /// A fixed-width string whose string order is the same as [compareTo],
  /// such as `001731600000000-00002-phone`.
  String pack() =>
      '${millis.toString().padLeft(_millisDigits, '0')}-'
      '${counter.toString().padLeft(_counterDigits, '0')}-'
      '$nodeId';

  @override
  int compareTo(Hlc other) {
    final byMillis = millis.compareTo(other.millis);
    if (byMillis != 0) return byMillis;
    final byCounter = counter.compareTo(other.counter);
    if (byCounter != 0) return byCounter;
    return nodeId.compareTo(other.nodeId);
  }

  bool operator <(Hlc other) => compareTo(other) < 0;

  bool operator >(Hlc other) => compareTo(other) > 0;

  @override
  bool operator ==(Object other) =>
      other is Hlc &&
      other.millis == millis &&
      other.counter == counter &&
      other.nodeId == nodeId;

  @override
  int get hashCode => Object.hash(millis, counter, nodeId);

  @override
  String toString() => pack();
}

/// One device's hybrid logical clock.
///
/// Call [tick] for every local change and [receive] for every change that
/// arrives from another device. After [receive], every later [tick] is
/// greater than the received timestamp, so an edit made after seeing
/// another device's edit always wins over it.
final class HybridLogicalClock(
  /// This device's id, stamped on every timestamp it makes.
  final String nodeId, {

  /// Reads the wall clock in milliseconds since the Unix epoch. Tests pass
  /// a fake.
  required final int Function() wallClock,
}) {
  var _latest = Hlc(0, 0, nodeId);

  /// The latest timestamp this clock has made or seen.
  Hlc get latest => _latest;

  /// A new timestamp for a local change, greater than every timestamp this
  /// clock has made or seen.
  Hlc tick() => _latest = _after(_latest.millis, _latest.counter);

  /// Moves this clock past [remote], a timestamp from another device.
  void receive(Hlc remote) {
    if (remote > _latest) {
      _latest = Hlc(remote.millis, remote.counter, nodeId);
    }
  }

  Hlc _after(int millis, int counter) {
    final now = wallClock();
    if (now > millis) return Hlc(now, 0, nodeId);
    if (counter < Hlc.maxCounter) return Hlc(millis, counter + 1, nodeId);
    // The counter is full: borrow a millisecond from the future. The wall
    // clock catches up within a moment.
    return Hlc(millis + 1, 0, nodeId);
  }
}
