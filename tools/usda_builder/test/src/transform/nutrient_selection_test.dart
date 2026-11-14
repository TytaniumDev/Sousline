import 'package:test/test.dart';
import 'package:usda_builder/src/fdc/fdc_nutrient.dart';
import 'package:usda_builder/src/fdc/fdc_release.dart';
import 'package:usda_builder/src/transform/nutrient_selection.dart';

void main() {
  const specs = [
    NutrientSpec('208', fallbacks: ['958', '957']),
    NutrientSpec('203'),
  ];

  group(NutrientSpec, () {
    test('tries the code before its fallbacks', () {
      expect(specs.first.sources, ['208', '958', '957']);
    });
  });

  group('selectedNutrients', () {
    test('has unique codes, including energy and the macros', () {
      final codes = selectedNutrients.map((s) => s.code).toList();

      expect(codes.toSet(), hasLength(codes.length));
      expect(codes, containsAll(['208', '203', '204', '205']));
    });
  });

  group('sourceNumbers', () {
    test('lists codes and fallbacks', () {
      expect(sourceNumbers(specs), {'208', '958', '957', '203'});
    });

    test('defaults to the selected nutrients', () {
      expect(sourceNumbers(), containsAll(['208', '958', '269.3']));
    });
  });

  group('selectNutrientValues', () {
    test('keeps only spec codes', () {
      expect(selectNutrientValues({'208': 32, '203': 0.6, '255': 90}, specs), {
        '208': 32,
        '203': 0.6,
      });
    });

    test('uses the first fallback with a value under the spec code', () {
      expect(selectNutrientValues({'957': 35, '958': 32}, specs), {'208': 32});
      expect(selectNutrientValues({'957': 35}, specs), {'208': 35});
    });

    test('prefers the code over its fallbacks', () {
      expect(selectNutrientValues({'208': 30, '958': 32}, specs), {'208': 30});
    });

    test('leaves out specs with no value', () {
      expect(selectNutrientValues({}, specs), isEmpty);
    });
  });

  group('describeNutrients', () {
    const energy = FdcNutrient(number: '208', name: 'Energy', unitName: 'KCAL');
    const protein = FdcNutrient(number: '203', name: 'Protein', unitName: 'G');
    const atwater = FdcNutrient(
      number: '958',
      name: 'Energy (Atwater Specific Factors)',
      unitName: 'KCAL',
    );

    test('describes each code with a lowercase unit, ordered by code', () {
      final described = describeNutrients({
        '208': energy,
        '203': protein,
        '958': atwater,
      }, specs);

      expect(described.map((n) => (n.code, n.name, n.unit)), [
        ('203', 'Protein', 'g'),
        ('208', 'Energy', 'kcal'),
      ]);
    });

    test('throws when a code is undefined', () {
      expect(
        () => describeNutrients({'208': energy}, specs),
        throwsA(isA<FdcReleaseException>()),
      );
    });

    test('throws when a fallback has a different unit', () {
      expect(
        () => describeNutrients({
          '208': energy,
          '203': protein,
          '957': const FdcNutrient(number: '957', name: 'kJ', unitName: 'KJ'),
        }, specs),
        throwsA(isA<FdcReleaseException>()),
      );
    });

    test('describes every selected nutrient', () {
      final definitions = {
        for (final number in sourceNumbers())
          number: FdcNutrient(number: number, name: number, unitName: 'G'),
      };

      expect(
        describeNutrients(definitions),
        hasLength(selectedNutrients.length),
      );
    });
  });
}
