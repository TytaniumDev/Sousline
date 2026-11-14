import 'package:measuring/measuring.dart';
import 'package:test/test.dart';

/// The single timer found in [text], as its label and both ends.
(String, Duration, Duration) _only(String text) {
  final timers = findTimers(text);
  expect(timers, hasLength(1), reason: text);
  final timer = timers.single;
  return (timer.text, timer.minimum, timer.maximum);
}

void main() {
  group('findTimers', () {
    group('single times', () {
      final cases = {
        'Bake for 20 minutes.': ('20 minutes', const Duration(minutes: 20)),
        'Simmer 1 hour.': ('1 hour', const Duration(hours: 1)),
        'Stir until fragrant, about 30 seconds.': (
          '30 seconds',
          const Duration(seconds: 30),
        ),
        'Air fry @ 360F for 8 mins': ('8 mins', const Duration(minutes: 8)),
        'Boil for ~8 min, or until tender': (
          '8 min',
          const Duration(minutes: 8),
        ),
        'Marinate for 2 hrs.': ('2 hrs', const Duration(hours: 2)),
        'Microwave for 10 secs.': ('10 secs', const Duration(seconds: 10)),
        'Roast for 25min.': ('25min', const Duration(minutes: 25)),
        'Rest for 3 Minutes.': ('3 Minutes', const Duration(minutes: 3)),
      };
      for (final MapEntry(key: text, value: (label, duration))
          in cases.entries) {
        test(text, () {
          expect(_only(text), (label, duration, duration));
        });
      }
    });

    group('fractions and decimals', () {
      final cases = {
        'Rise until doubled, about 1 1/2 hours.': (
          '1 1/2 hours',
          const Duration(minutes: 90),
        ),
        'Cook for about 1 ½ minutes, then flip.': (
          '1 ½ minutes',
          const Duration(seconds: 90),
        ),
        'Cook for 1½ hours.': ('1½ hours', const Duration(minutes: 90)),
        'Steep for ½ hour.': ('½ hour', const Duration(minutes: 30)),
        'Chill 1.5 hours.': ('1.5 hours', const Duration(minutes: 90)),
        'Bake 3/4 hour.': ('3/4 hour', const Duration(minutes: 45)),
        'Pulse for 0.25 minutes.': (
          '0.25 minutes',
          const Duration(seconds: 15),
        ),
      };
      for (final MapEntry(key: text, value: (label, duration))
          in cases.entries) {
        test(text, () {
          expect(_only(text), (label, duration, duration));
        });
      }
    });

    group('words', () {
      final cases = {
        'Beat on medium speed for two minutes.': (
          'two minutes',
          const Duration(minutes: 2),
        ),
        'Let sit one minute before removing.': (
          'one minute',
          const Duration(minutes: 1),
        ),
        'Simmer for an hour.': ('an hour', const Duration(hours: 1)),
        'Toast for a minute.': ('a minute', const Duration(minutes: 1)),
        'Set aside for about half an hour.': (
          'half an hour',
          const Duration(minutes: 30),
        ),
        'Rest for a half hour.': ('a half hour', const Duration(minutes: 30)),
        'Whisk for half a minute.': (
          'half a minute',
          const Duration(seconds: 30),
        ),
        'Braise for an hour and a half.': (
          'an hour and a half',
          const Duration(minutes: 90),
        ),
        'Cook for another couple minutes.': (
          'couple minutes',
          const Duration(minutes: 2),
        ),
        'Cook for a couple of minutes.': (
          'a couple of minutes',
          const Duration(minutes: 2),
        ),
        'Rest for forty-five minutes.': (
          'forty-five minutes',
          const Duration(minutes: 45),
        ),
        'Sauté for five minutes.': ('five minutes', const Duration(minutes: 5)),
      };
      for (final MapEntry(key: text, value: (label, duration))
          in cases.entries) {
        test(text, () {
          expect(_only(text), (label, duration, duration));
        });
      }
    });

    group('ranges', () {
      final cases = {
        'Bake 20 to 25 minutes.': (
          '20 to 25 minutes',
          const Duration(minutes: 20),
          const Duration(minutes: 25),
        ),
        'Bake for 20-25 minutes.': (
          '20-25 minutes',
          const Duration(minutes: 20),
          const Duration(minutes: 25),
        ),
        'Cook until browned, about 8–10 minutes.': (
          '8–10 minutes',
          const Duration(minutes: 8),
          const Duration(minutes: 10),
        ),
        'Bake for 10 – 15 minutes.': (
          '10 – 15 minutes',
          const Duration(minutes: 10),
          const Duration(minutes: 15),
        ),
        'Simmer gently for 1 1/2 to 2 hours.': (
          '1 1/2 to 2 hours',
          const Duration(minutes: 90),
          const Duration(hours: 2),
        ),
        'Refry for 30 to 60 seconds.': (
          '30 to 60 seconds',
          const Duration(seconds: 30),
          const Duration(minutes: 1),
        ),
        'Cook for a minute or two.': (
          'a minute or two',
          const Duration(minutes: 1),
          const Duration(minutes: 2),
        ),
        'Bake 45 minutes to 1 hour.': (
          '45 minutes to 1 hour',
          const Duration(minutes: 45),
          const Duration(hours: 1),
        ),
        'Marinate for 30min-5 hours in the fridge.': (
          '30min-5 hours',
          const Duration(minutes: 30),
          const Duration(hours: 5),
        ),
        'Refrigerate at least 1 hour or up to 12 hours.': (
          '1 hour or up to 12 hours',
          const Duration(hours: 1),
          const Duration(hours: 12),
        ),
        'Marinate for at least 6 hours, up to 48 hours.': (
          '6 hours, up to 48 hours',
          const Duration(hours: 6),
          const Duration(hours: 48),
        ),
        'Leave for at least 10 minutes and up to 30 minutes.': (
          '10 minutes and up to 30 minutes',
          const Duration(minutes: 10),
          const Duration(minutes: 30),
        ),
      };
      for (final MapEntry(key: text, value: (label, minimum, maximum))
          in cases.entries) {
        test(text, () {
          expect(_only(text), (label, minimum, maximum));
        });
      }

      test('marks only ranges as ranges', () {
        expect(findTimers('Bake 20 to 25 minutes.').single.isRange, isTrue);
        expect(findTimers('Bake 20 minutes.').single.isRange, isFalse);
      });
    });

    group('hours and minutes', () {
      final cases = {
        'Bake 1 hour 15 minutes.': (
          '1 hour 15 minutes',
          const Duration(hours: 1, minutes: 15),
        ),
        'Bake 1 hour and 15 minutes.': (
          '1 hour and 15 minutes',
          const Duration(hours: 1, minutes: 15),
        ),
        'Smoke for 2 hrs 30 mins.': (
          '2 hrs 30 mins',
          const Duration(hours: 2, minutes: 30),
        ),
        'Blend for 1 minute 30 seconds.': (
          '1 minute 30 seconds',
          const Duration(seconds: 90),
        ),
      };
      for (final MapEntry(key: text, value: (label, duration))
          in cases.entries) {
        test(text, () {
          expect(_only(text), (label, duration, duration));
        });
      }

      test('does not add a larger unit after a smaller one', () {
        final timers = findTimers('Rest 30 minutes 2 hours later.');

        expect(timers.map((timer) => timer.text), ['30 minutes', '2 hours']);
      });

      test('does not add a time to a range', () {
        final timers = findTimers('Bake 1 to 2 hours 10 minutes.');

        expect(timers.map((timer) => timer.text), [
          '1 to 2 hours',
          '10 minutes',
        ]);
      });
    });

    group('overnight', () {
      test('is 8 to 12 hours', () {
        expect(_only('Cover and refrigerate overnight.'), (
          'overnight',
          overnightMinimum,
          overnightMaximum,
        ));
        expect(overnightMinimum, const Duration(hours: 8));
        expect(overnightMaximum, const Duration(hours: 12));
      });

      final found = [
        'Refrigerate overnight',
        'Seal with a lid and refrigerate overnight to set',
        'Refrigerate overnight or at least 5-6 hours',
        'Marinate in the fridge over night.',
        'Let it marinate overnight in the fridge.',
        'Chill overnight (or at least 4 hours).',
        'Refrigerate Overnight, then bake.',
      ];
      for (final text in found) {
        test('finds it in "$text"', () {
          expect(
            findTimers(text)
                .where((timer) => timer.maximum == overnightMaximum),
            hasLength(1),
          );
        });
      }

      final ignored = [
        'Portion overnight oats into two containers.',
        '(Or use the overnight option below.)',
        'Stopover nights are fun.',
      ];
      for (final text in ignored) {
        test('ignores it in "$text"', () {
          expect(findTimers(text), isEmpty);
        });
      }

      test('stays separate from another time', () {
        final timers = findTimers('Refrigerate at least 6 hours or overnight.');

        expect(timers.map((timer) => timer.text), ['6 hours', 'overnight']);
      });
    });

    group('several times', () {
      test('are returned in order with their offsets', () {
        const text =
            'Bake 20 minutes in the fridge or 2 hours at room temperature.';
        final timers = findTimers(text);

        expect(timers.map((timer) => timer.text), ['20 minutes', '2 hours']);
        for (final timer in timers) {
          expect(text.substring(timer.start, timer.end), timer.text);
        }
      });

      test('keep step order when overnight comes first', () {
        final timers = findTimers('Soak overnight, then simmer 30 minutes.');

        expect(timers.map((timer) => timer.text), ['overnight', '30 minutes']);
      });
    });

    group('ignores', () {
      final ignored = [
        'Preheat the oven to 350°F.',
        'Stir every 15 minutes.',
        'Turn the skewers each 5 minutes.',
        'Keeps in the fridge for up to 3 hours.',
        'Store for up to 5 days.',
        'Let it ferment for 2 to 3 days.',
        'Cook for a few minutes.',
        'Rest for several minutes.',
        'A 30-minute dinner.',
        'Add 2 cups minced garlic.',
        'Cut into 2 inch pieces.',
        'Rest the dough for 10.',
        'Use the minute rice.',
        'Whisk in a second large bowl.',
        '',
      ];
      for (final text in ignored) {
        test('"$text"', () {
          expect(findTimers(text), isEmpty);
        });
      }
    });
  });
}
