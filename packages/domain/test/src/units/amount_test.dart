import 'package:domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group(Amount, () {
    test('one third cup times three is exactly one cup', () {
      final third = Amount(Quantity(1, 3), Unit.cup);

      expect(third.scaled(Quantity(3)), const Amount(Quantity.one, Unit.cup));
    });

    test('scales a bare count', () {
      expect(
        Amount(Quantity(2), null).scaled(Quantity(3, 2)),
        Amount(Quantity(3), null),
      );
    });

    test('has value equality', () {
      expect(
        Amount(Quantity(2, 4), Unit.cup),
        Amount(Quantity(1, 2), Unit.cup),
      );
      expect(
        Amount(Quantity(1, 2), Unit.cup).hashCode,
        Amount(Quantity(2, 4), Unit.cup).hashCode,
      );
      expect(
        Amount(Quantity(1, 2), Unit.cup),
        isNot(Amount(Quantity(1, 2), Unit.tablespoon)),
      );
    });

    test('prints a debug form', () {
      expect(Amount(Quantity(1, 3), Unit.cup).toString(), '1/3 cup');
      expect(Amount(Quantity(2), null).toString(), '2');
    });
  });
}
