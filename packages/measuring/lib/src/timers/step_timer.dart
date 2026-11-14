import 'package:meta/meta.dart';

/// A time mentioned in a step's text, such as "20 to 25 minutes", that
/// cooking mode can turn into a `TimerChip`.
///
/// A single time has the same [minimum] and [maximum]. A range such as
/// "20 to 25 minutes" has both ends, and the app chooses which one the timer
/// counts down from.
@immutable
final class const StepTimer({
  /// Where the time starts in the step text, as a UTF-16 offset.
  required final int start,

  /// Where the time ends in the step text, exclusive.
  required final int end,

  /// The time exactly as written, such as "1 ½ hours". Shown as the chip's
  /// label, so it reads the same as the step.
  required final String text,

  /// The shortest time the step asks for.
  required final Duration minimum,

  /// The longest time the step asks for. Equal to [minimum] unless the step
  /// gives a range.
  required final Duration maximum,
}) {
  /// Whether the step gives a range, such as "20 to 25 minutes".
  bool get isRange => minimum != maximum;

  @override
  bool operator ==(Object other) =>
      other is StepTimer &&
      other.start == start &&
      other.end == end &&
      other.text == text &&
      other.minimum == minimum &&
      other.maximum == maximum;

  @override
  int get hashCode => Object.hash(start, end, text, minimum, maximum);

  @override
  String toString() => 'StepTimer($text, $minimum–$maximum, $start..$end)';
}
