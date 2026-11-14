import 'package:domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group('measurableAmount', () {
    // Each row: the value and its unit, then the amount it rounds to.
    final table = <(double, Unit?), Amount>{
      // US volume: teaspoons below 1 tbsp, to the nearest 1/8.
      (1 / 16, Unit.teaspoon): Amount(Quantity(1, 8), Unit.teaspoon),
      (0.6, Unit.teaspoon): Amount(Quantity(5, 8), Unit.teaspoon),
      (2.95, Unit.teaspoon): const Amount(Quantity.one, Unit.tablespoon),
      // Tablespoons to the nearest 1/2, or teaspoons when that is too far.
      (7.5, Unit.teaspoon): Amount(Quantity(5, 2), Unit.tablespoon),
      (4, Unit.teaspoon): Amount(Quantity(4), Unit.teaspoon),
      (5, Unit.teaspoon): Amount(Quantity(5), Unit.teaspoon),
      // Cups in friendly fractions.
      (11.9, Unit.teaspoon): Amount(Quantity(1, 4), Unit.cup),
      (16, Unit.teaspoon): Amount(Quantity(1, 3), Unit.cup),
      (5 / 2, Unit.cup): Amount(Quantity(5, 2), Unit.cup),
      (2.0 / 3 * 1.5, Unit.cup): const Amount(Quantity.one, Unit.cup),
      // Below 1 cup, tablespoons when no fraction of a cup is close.
      (5 / 12, Unit.cup): Amount(Quantity(13, 2), Unit.tablespoon),
      // Above 1 cup, the nearest 1/8 cup.
      (17 / 12, Unit.cup): Amount(Quantity(11, 8), Unit.cup),
      // Fluid ounces, pints, quarts, and gallons stay as written.
      (3, Unit.quart): Amount(Quantity(3), Unit.quart),
      (1.3, Unit.gallon): Amount(Quantity(5, 4), Unit.gallon),
      (12.1, Unit.fluidOunce): Amount(Quantity(12), Unit.fluidOunce),
      (0.5, Unit.quart): Amount(Quantity(2), Unit.cup),
      // Metric volume.
      (7.3, Unit.milliliter): Amount(Quantity(15, 2), Unit.milliliter),
      (42.4, Unit.milliliter): Amount(Quantity(42), Unit.milliliter),
      (236.588, Unit.milliliter): Amount(Quantity(235), Unit.milliliter),
      (1250, Unit.milliliter): Amount(Quantity(5, 4), Unit.liter),
      (3.7854, Unit.liter): Amount(Quantity(19, 5), Unit.liter),
      // Metric mass.
      (998, Unit.gram): const Amount(Quantity.one, Unit.kilogram),
      (0.35, Unit.kilogram): Amount(Quantity(350), Unit.gram),
      // US mass.
      (6.3, Unit.ounce): Amount(Quantity(25, 4), Unit.ounce),
      (15.9, Unit.ounce): const Amount(Quantity.one, Unit.pound),
      (1.1, Unit.pound): const Amount(Quantity.one, Unit.pound),
      // Counts and bare numbers.
      (0.1, null): Amount(Quantity(1, 4), null),
      (0.6, null): Amount(Quantity(1, 2), null),
      (2.25, null): Amount(Quantity(5, 2), null),
      (12.4, null): Amount(Quantity(12), null),
      (1.5, Unit.pinch): Amount(Quantity(3, 2), Unit.pinch),
    };

    for (final MapEntry(key: (value, unit), value: expected) in table.entries) {
      test('$value ${unit?.name ?? ''} rounds to $expected', () {
        expect(measurableAmount(value, unit), expected);
      });
    }

    test('gives zero for zero or less', () {
      expect(
        measurableAmount(0, Unit.cup),
        const Amount(Quantity.zero, Unit.cup),
      );
      expect(measurableAmount(-1, null), const Amount(Quantity.zero, null));
    });
  });

  group('MeasurableRounding', () {
    test('rounds a scaled amount in its own family', () {
      final scaled = Amount(
        Quantity(1, 4),
        Unit.teaspoon,
      ).scaled(Quantity(1, 3));

      expect(
        scaled.roundedToMeasurable(),
        Amount(Quantity(1, 8), Unit.teaspoon),
      );
    });

    test('keeps exact friendly amounts exact', () {
      final scaled = Amount(Quantity(1, 3), Unit.cup).scaled(Quantity(2));

      expect(scaled.roundedToMeasurable(), Amount(Quantity(2, 3), Unit.cup));
    });

    group('measurableIn', () {
      final table = <(Amount, UnitSystem), Amount>{
        (const Amount(Quantity.one, Unit.cup), UnitSystem.metric): Amount(
          Quantity(235),
          Unit.milliliter,
        ),
        (Amount(Quantity(250), Unit.milliliter), UnitSystem.us): const Amount(
          Quantity.one,
          Unit.cup,
        ),
        (const Amount(Quantity.one, Unit.pound), UnitSystem.metric): Amount(
          Quantity(455),
          Unit.gram,
        ),
        (Amount(Quantity(500), Unit.gram), UnitSystem.us): const Amount(
          Quantity.one,
          Unit.pound,
        ),
        (Amount(Quantity(1, 2), Unit.cup), UnitSystem.us): Amount(
          Quantity(1, 2),
          Unit.cup,
        ),
        (Amount(Quantity(1, 2), Unit.cup), UnitSystem.original): Amount(
          Quantity(1, 2),
          Unit.cup,
        ),
        (Amount(Quantity(2), Unit.pinch), UnitSystem.metric): Amount(
          Quantity(2),
          Unit.pinch,
        ),
        (Amount(Quantity(3), null), UnitSystem.metric): Amount(
          Quantity(3),
          null,
        ),
      };

      for (final MapEntry(key: (amount, system), value: expected)
          in table.entries) {
        test('$amount in ${system.name} is $expected', () {
          expect(amount.measurableIn(system), expected);
        });
      }
    });
  });
}
