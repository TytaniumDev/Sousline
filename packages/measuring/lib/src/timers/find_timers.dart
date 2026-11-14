import 'dart:math';

import 'package:domain/domain.dart';
import 'package:measuring/src/timers/step_timer.dart';

/// How long "overnight" is: 8 to 12 hours.
const overnightMinimum = Duration(hours: 8);

/// The upper end of "overnight". See [overnightMinimum].
const overnightMaximum = Duration(hours: 12);

/// Finds the times in a step's [text] that cooking mode can offer as
/// timers, in the order they appear.
///
/// Understands seconds, minutes, and hours written as numbers ("20",
/// "1 ½", "1.5", "1 1/2") or words ("one", "an", "half an hour"), ranges
/// ("20 to 25 minutes", "45 minutes to 1 hour", "at least 1 hour or up to
/// 12 hours"), compound times ("1 hour 15 minutes"), and "overnight".
///
/// Leaves out times that are not something to wait for: intervals ("stir
/// every 5 minutes"), limits on their own ("keeps for up to 3 hours"), days
/// (storage, not cooking), and vague amounts ("a few minutes").
List<StepTimer> findTimers(String text) {
  final timers = <StepTimer>[
    ..._mergeSpans(_spansIn(text), text).map((span) => span.toTimer(text)),
    ..._overnightTimers(text),
  ]..sort((a, b) => a.start.compareTo(b.start));
  return timers;
}

/// A matched time before it becomes a [StepTimer].
final class _Span(
  final int start,
  final int end,
  final Duration minimum,
  final Duration maximum,
) {
  bool get isRange => minimum != maximum;

  /// Whether this span covers [other] and more, such as "half an hour"
  /// covering "an hour".
  bool contains(_Span other) =>
      start <= other.start &&
      end >= other.end &&
      (end - start) > (other.end - other.start);

  StepTimer toTimer(String text) => StepTimer(
    start: start,
    end: end,
    text: text.substring(start, end),
    minimum: minimum,
    maximum: maximum,
  );
}

const _unicodeFractions = {
  '½': (1, 2),
  '⅓': (1, 3),
  '⅔': (2, 3),
  '¼': (1, 4),
  '¾': (3, 4),
  '⅕': (1, 5),
  '⅖': (2, 5),
  '⅗': (3, 5),
  '⅘': (4, 5),
  '⅙': (1, 6),
  '⅚': (5, 6),
  '⅛': (1, 8),
  '⅜': (3, 8),
  '⅝': (5, 8),
  '⅞': (7, 8),
};

const _numberWords = {
  'a': 1,
  'an': 1,
  'one': 1,
  'two': 2,
  'three': 3,
  'four': 4,
  'five': 5,
  'six': 6,
  'seven': 7,
  'eight': 8,
  'nine': 9,
  'ten': 10,
  'eleven': 11,
  'twelve': 12,
  'fifteen': 15,
  'twenty': 20,
  'thirty': 30,
  'forty': 40,
  'forty-five': 45,
  'fifty': 50,
  'sixty': 60,
  'ninety': 90,
};

/// Each unit's length in microseconds, keyed by the unit's first letters.
const Map<String, int> _unitMicroseconds = {
  'sec': Duration.microsecondsPerSecond,
  'min': Duration.microsecondsPerMinute,
  'hou': Duration.microsecondsPerHour,
  'hr': Duration.microsecondsPerHour,
};

final String _fractionChars = _unicodeFractions.keys.join();

/// Number words, longest first so "forty-five" wins over "forty".
final String _numberWordPattern =
    (_numberWords.keys.toList()..sort((a, b) => b.length - a.length)).join('|');

/// One number: a mixed number ("1 1/2", "1 ½"), a fraction, a decimal, a
/// whole number, a Unicode fraction, or a number word.
final _number =
    '(?:\\d+\\s+\\d+/\\d+|\\d+\\s*[$_fractionChars]|\\d+/\\d+'
    '|\\d+(?:\\.\\d+)?|[$_fractionChars]'
    r'|(?:a\s+)?couple(?:\s+of)?'
    '|$_numberWordPattern)';

const _unit = '(?:seconds?|secs?|minutes?|mins?|hours?|hrs?)';

const _dash = '(?:-|–|—|to)';

/// "20 minutes", "20 to 25 minutes", "an hour and a half", "a minute or
/// two".
final _amountPattern = RegExp(
  '(?<![\\p{L}\\p{N}./])(?<from>$_number)'
  '(?:\\s*$_dash\\s*(?<to>$_number))?'
  '\\s*(?<unit>$_unit)'
  r'(?<half>\s+and\s+a\s+half)?'
  r'(?<orTwo>\s+or\s+two)?'
  r'(?![\p{L}\p{N}])',
  caseSensitive: false,
  unicode: true,
);

/// "half an hour", "a half hour", "half a minute".
final _halfPattern = RegExp(
  r'(?<![\p{L}\p{N}])(?:a\s+)?half\s+(?:an?\s+)?(?<unit>hour|minute)'
  r'(?![\p{L}\p{N}])',
  caseSensitive: false,
  unicode: true,
);

/// "overnight" or "over night", when it is a time and not a name such as
/// "overnight oats": it must be followed by punctuation, the end of the
/// text, or a small word.
final _overnightPattern = RegExp(
  r'(?<![\p{L}\p{N}])over\s?night(?=\s*(?:$|[^\p{L}\s]|'
  '(?:or|to|and|in|at|for|before|until|then|so|is|if|while|covered'
  r'|uncovered|on|with)(?![\p{L}])))',
  caseSensitive: false,
  unicode: true,
);

/// Text between two times that makes them one range: "45 minutes to
/// 1 hour", "30 minutes, up to 12 hours", "1 hour or up to 12 hours".
final _rangeGap = RegExp(
  r'^\s*(?:-|–|—|to|,?\s*(?:(?:and|or)\s+)?up\s+to)\s*$',
  caseSensitive: false,
);

/// Text between two times that makes them one total: "1 hour 15 minutes",
/// "1 hour and 15 minutes".
final _compoundGap = RegExp(r'^\s+(?:and\s+)?$', caseSensitive: false);

/// Text just before a time that makes it an interval or a limit, not a
/// wait: "every 5 minutes", "up to 3 hours".
final _excludedBefore = RegExp(
  r'(?:\bevery|\beach|\bup\s+to)\s*$',
  caseSensitive: false,
);

List<_Span> _spansIn(String text) {
  final spans = <_Span>[
    for (final match in _amountPattern.allMatches(text))
      if (!_isOrdinal(match)) _amountSpan(match),
    for (final match in _halfPattern.allMatches(text))
      _Span(
        match.start,
        match.end,
        _duration(Quantity(1, 2), match.namedGroup('unit')!),
        _duration(Quantity(1, 2), match.namedGroup('unit')!),
      ),
  ]..sort((a, b) => a.start.compareTo(b.start));
  return [
    for (final span in spans)
      if (!spans.any((other) => other != span && other.contains(span))) span,
  ];
}

/// Whether [match] is "a second" used as an ordinal, as in "a second bowl".
bool _isOrdinal(RegExpMatch match) =>
    match.namedGroup('unit')!.toLowerCase() == 'second' &&
    match.namedGroup('from')!.toLowerCase() == 'a';

_Span _amountSpan(RegExpMatch match) {
  final unit = match.namedGroup('unit')!;
  final half = match.namedGroup('half') == null
      ? Quantity.zero
      : Quantity(1, 2);
  final from = _parseNumber(match.namedGroup('from')!) + half;
  final toText = match.namedGroup('to');
  final to = match.namedGroup('orTwo') != null
      ? Quantity(2)
      : toText == null
      ? from
      : _parseNumber(toText) + half;
  return _Span(
    match.start,
    match.end,
    _duration(from, unit),
    _duration(to, unit),
  );
}

/// Joins compound times and ranges written across two times, and drops
/// times that are intervals or limits.
List<_Span> _mergeSpans(List<_Span> spans, String text) {
  final merged = <_Span>[];
  for (final span in spans) {
    final previous = merged.isEmpty ? null : merged.last;
    final gap = previous == null
        ? null
        : text.substring(previous.end, span.start);
    if (previous != null && gap != null && span.start >= previous.end) {
      if (_compoundGap.hasMatch(gap) &&
          !previous.isRange &&
          span.maximum < previous.minimum) {
        merged.last = _Span(
          previous.start,
          span.end,
          previous.minimum + span.minimum,
          previous.maximum + span.maximum,
        );
        continue;
      }
      if (_rangeGap.hasMatch(gap) && span.maximum > previous.maximum) {
        merged.last = _Span(
          previous.start,
          span.end,
          previous.minimum,
          span.maximum,
        );
        continue;
      }
    }
    if (_excludedBefore.hasMatch(text.substring(0, span.start))) continue;
    merged.add(span);
  }
  return merged;
}

Iterable<StepTimer> _overnightTimers(String text) => _overnightPattern
    .allMatches(text)
    .map(
      (match) => StepTimer(
        start: match.start,
        end: match.end,
        text: match.group(0)!,
        minimum: overnightMinimum,
        maximum: overnightMaximum,
      ),
    );

Quantity _parseNumber(String raw) {
  final text = raw.toLowerCase().trim();
  if (text.contains('couple')) return Quantity(2);
  final word = _numberWords[text];
  if (word != null) return Quantity(word);
  final mixed = RegExp(r'^(\d+)\s+(\d+)/(\d+)$').firstMatch(text);
  if (mixed != null) {
    return Quantity(int.parse(mixed[1]!)) +
        Quantity(int.parse(mixed[2]!), int.parse(mixed[3]!));
  }
  final fraction = RegExp(r'^(\d+)/(\d+)$').firstMatch(text);
  if (fraction != null) {
    return Quantity(int.parse(fraction[1]!), int.parse(fraction[2]!));
  }
  final unicode = _unicodeFractions[text[text.length - 1]];
  if (unicode != null) {
    final whole = text.substring(0, text.length - 1).trim();
    return Quantity(whole.isEmpty ? 0 : int.parse(whole)) +
        Quantity(unicode.$1, unicode.$2);
  }
  final decimal = text.split('.');
  if (decimal.length == 2) {
    return Quantity(
      int.parse(decimal.join()),
      pow(10, decimal[1].length).toInt(),
    );
  }
  return Quantity(int.parse(text));
}

Duration _duration(Quantity amount, String unit) {
  final key = _unitMicroseconds.keys.firstWhere(
    (prefix) => unit.toLowerCase().startsWith(prefix),
  );
  final micros = amount * Quantity(_unitMicroseconds[key]!);
  return Duration(microseconds: micros.toDouble().round());
}
