import 'package:domain/domain.dart';
import 'package:test/test.dart';

void main() {
  group(Unit, () {
    test('groups units by what they measure', () {
      expect(Unit.cup.dimension, UnitDimension.volume);
      expect(Unit.gram.dimension, UnitDimension.mass);
      expect(Unit.pinch.dimension, UnitDimension.count);
    });

    test('belongs to a family and a measuring system', () {
      expect(Unit.tablespoon.family, UnitFamily.usVolume);
      expect(Unit.liter.family, UnitFamily.metricVolume);
      expect(Unit.pound.family, UnitFamily.usMass);
      expect(Unit.kilogram.family, UnitFamily.metricMass);
      expect(Unit.cup.system, UnitSystem.us);
      expect(Unit.gram.system, UnitSystem.metric);
      expect(Unit.piece.system, isNull);
    });

    test('counts its family in whole base units', () {
      expect(Unit.teaspoon.baseUnits, 1);
      expect(Unit.tablespoon.baseUnits, 3);
      expect(Unit.cup.baseUnits, 48);
      expect(Unit.gallon.baseUnits, 768);
      expect(Unit.liter.baseUnits, 1000);
      expect(Unit.pound.baseUnits, 16);
    });

    test('converts exactly only within its family', () {
      expect(Unit.cup.isConvertibleTo(Unit.teaspoon), isTrue);
      expect(Unit.cup.isConvertibleTo(Unit.cup), isTrue);
      expect(Unit.cup.isConvertibleTo(Unit.milliliter), isFalse);
      expect(Unit.cup.isConvertibleTo(Unit.gram), isFalse);
    });

    test('keeps each count unit to itself', () {
      expect(Unit.pinch.isConvertibleTo(Unit.pinch), isTrue);
      expect(Unit.pinch.isConvertibleTo(Unit.piece), isFalse);
    });
  });
}
