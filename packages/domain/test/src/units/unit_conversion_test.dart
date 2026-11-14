import 'package:domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group('AmountConversion', () {
    group('convertTo', () {
      final table = <(Amount, Unit), Amount>{
        (Amount(Quantity(3), Unit.teaspoon), Unit.tablespoon): const Amount(
          Quantity.one,
          Unit.tablespoon,
        ),
        (Amount(Quantity(1, 3), Unit.cup), Unit.teaspoon): Amount(
          Quantity(16),
          Unit.teaspoon,
        ),
        (Amount(Quantity(1, 4), Unit.cup), Unit.tablespoon): Amount(
          Quantity(4),
          Unit.tablespoon,
        ),
        (Amount(Quantity(2), Unit.pint), Unit.quart): const Amount(
          Quantity.one,
          Unit.quart,
        ),
        (Amount(Quantity(1), Unit.gallon), Unit.cup): Amount(
          Quantity(16),
          Unit.cup,
        ),
        (Amount(Quantity(8), Unit.fluidOunce), Unit.cup): const Amount(
          Quantity.one,
          Unit.cup,
        ),
        (Amount(Quantity(1500), Unit.milliliter), Unit.liter): Amount(
          Quantity(3, 2),
          Unit.liter,
        ),
        (Amount(Quantity(1, 4), Unit.kilogram), Unit.gram): Amount(
          Quantity(250),
          Unit.gram,
        ),
        (Amount(Quantity(24), Unit.ounce), Unit.pound): Amount(
          Quantity(3, 2),
          Unit.pound,
        ),
        (Amount(Quantity(2), Unit.pinch), Unit.pinch): Amount(
          Quantity(2),
          Unit.pinch,
        ),
      };

      for (final MapEntry(key: (amount, target), value: expected)
          in table.entries) {
        test('$amount is exactly $expected', () {
          expect(amount.convertTo(target), expected);
        });
      }

      test('returns null across families', () {
        expect(
          const Amount(Quantity.one, Unit.cup).convertTo(Unit.milliliter),
          null,
        );
        expect(const Amount(Quantity.one, Unit.cup).convertTo(Unit.gram), null);
        expect(
          const Amount(Quantity.one, Unit.pinch).convertTo(Unit.piece),
          null,
        );
      });

      test('returns null without a unit', () {
        expect(const Amount(Quantity.one, null).convertTo(Unit.cup), null);
      });
    });

    group('approximateValueIn', () {
      test('matches the exact conversion within a family', () {
        expect(
          Amount(Quantity(1, 2), Unit.cup).approximateValueIn(Unit.tablespoon),
          8,
        );
      });

      test('converts US volume to metric', () {
        expect(
          const Amount(
            Quantity.one,
            Unit.cup,
          ).approximateValueIn(Unit.milliliter),
          closeTo(236.588, 0.001),
        );
        expect(
          const Amount(
            Quantity.one,
            Unit.gallon,
          ).approximateValueIn(Unit.liter),
          closeTo(3.785, 0.001),
        );
      });

      test('converts metric volume to US', () {
        expect(
          Amount(
            Quantity(15),
            Unit.milliliter,
          ).approximateValueIn(Unit.teaspoon),
          closeTo(3.043, 0.001),
        );
      });

      test('converts US mass to metric', () {
        expect(
          const Amount(Quantity.one, Unit.pound).approximateValueIn(Unit.gram),
          closeTo(453.592, 0.001),
        );
      });

      test('converts metric mass to US', () {
        expect(
          const Amount(
            Quantity.one,
            Unit.kilogram,
          ).approximateValueIn(Unit.pound),
          closeTo(2.2046, 0.0001),
        );
      });

      test('returns null between volume and mass', () {
        expect(
          const Amount(Quantity.one, Unit.cup).approximateValueIn(Unit.gram),
          null,
        );
      });

      test('returns null between different counts', () {
        expect(
          const Amount(Quantity.one, Unit.pinch).approximateValueIn(Unit.piece),
          null,
        );
      });

      test('returns null without a unit', () {
        expect(
          const Amount(Quantity.one, null).approximateValueIn(Unit.cup),
          null,
        );
      });
    });
  });
}
