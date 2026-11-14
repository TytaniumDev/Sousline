/// An exact fraction, always reduced, with a positive denominator.
typedef Fraction = ({int numerator, int denominator});

/// Denominators that household measures use, smallest first.
const _householdDenominators = [2, 3, 4, 6, 8, 12, 16];

/// How far a decimal may be from a household fraction and still count as
/// it. USDA rounds 1/3 to "0.33" and 1/6 to "0.16".
const _tolerance = 0.01;

/// Converts a release amount such as "0.33" or "6.75" to an exact fraction.
///
/// Prefers household fractions (thirds, quarters, sixteenths) within a
/// small tolerance, so USDA's rounded "0.33" becomes 1/3. Otherwise the
/// decimal is taken exactly, so "0.2" becomes 1/5. Returns null for text
/// that is not a positive number.
Fraction? amountFraction(String text) {
  final value = double.tryParse(text);
  if (value == null || !value.isFinite || value <= 0) return null;

  final whole = value.floor();
  final part = value - whole;
  if (part.abs() < 1e-9) return (numerator: whole, denominator: 1);
  for (final denominator in _householdDenominators) {
    final numerator = (part * denominator).round();
    if (numerator > 0 &&
        numerator < denominator &&
        (part - numerator / denominator).abs() <= _tolerance) {
      return _reduced(whole * denominator + numerator, denominator);
    }
  }
  return _exactDecimal(text.trim());
}

/// Reads a decimal such as "5.3" exactly from its digits.
Fraction? _exactDecimal(String text) {
  final match = RegExp(r'^(\d*)\.(\d+)$').firstMatch(text);
  if (match == null) return null;
  final digits = match[2]!;
  final denominator = BigInt.from(10).pow(digits.length).toInt();
  final numerator = int.parse('${match[1]}$digits');
  return _reduced(numerator, denominator);
}

Fraction _reduced(int numerator, int denominator) {
  final divisor = numerator.gcd(denominator);
  return (numerator: numerator ~/ divisor, denominator: denominator ~/ divisor);
}
