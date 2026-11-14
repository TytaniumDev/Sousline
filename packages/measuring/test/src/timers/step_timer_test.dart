import 'package:measuring/measuring.dart';
import 'package:test/test.dart';

void main() {
  group(StepTimer, () {
    const timer = StepTimer(
      start: 5,
      end: 15,
      text: '20 minutes',
      minimum: Duration(minutes: 20),
      maximum: Duration(minutes: 20),
    );

    test('compares by value', () {
      const same = StepTimer(
        start: 5,
        end: 15,
        text: '20 minutes',
        minimum: Duration(minutes: 20),
        maximum: Duration(minutes: 20),
      );

      expect(timer, same);
      expect(timer.hashCode, same.hashCode);
      expect(
        timer,
        isNot(
          const StepTimer(
            start: 6,
            end: 16,
            text: '20 minutes',
            minimum: Duration(minutes: 20),
            maximum: Duration(minutes: 20),
          ),
        ),
      );
    });

    test('describes itself', () {
      expect(timer.toString(), contains('20 minutes'));
    });
  });
}
