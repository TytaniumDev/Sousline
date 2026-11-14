import 'package:test/test.dart';
import 'package:usda_builder/src/transform/amount_fraction.dart';

void main() {
  group('amountFraction', () {
    final cases = {
      '1': (numerator: 1, denominator: 1),
      '1.0': (numerator: 1, denominator: 1),
      '100.0': (numerator: 100, denominator: 1),
      '0.5': (numerator: 1, denominator: 2),
      '0.25': (numerator: 1, denominator: 4),
      '0.75': (numerator: 3, denominator: 4),
      '1.5': (numerator: 3, denominator: 2),
      '6.75': (numerator: 27, denominator: 4),
      // USDA rounds household fractions to two places.
      '0.33': (numerator: 1, denominator: 3),
      '0.67': (numerator: 2, denominator: 3),
      '0.16': (numerator: 1, denominator: 6),
      '0.12': (numerator: 1, denominator: 8),
      '0.08': (numerator: 1, denominator: 12),
      '10.33': (numerator: 31, denominator: 3),
      // Everything else is taken exactly.
      '0.2': (numerator: 1, denominator: 5),
      '0.3': (numerator: 3, denominator: 10),
      '5.3': (numerator: 53, denominator: 10),
      ' 3.52 ': (numerator: 88, denominator: 25),
    };
    for (final MapEntry(key: text, value: fraction) in cases.entries) {
      test(
        'reads "$text" as ${fraction.numerator}/${fraction.denominator}',
        () {
          expect(amountFraction(text), fraction);
        },
      );
    }

    for (final text in [
      '',
      'abc',
      '0',
      '0.0',
      '-1',
      'NaN',
      'Infinity',
      '1e-5',
    ]) {
      test('rejects "$text"', () => expect(amountFraction(text), isNull));
    }
  });
}
