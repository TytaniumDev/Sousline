import 'dart:io';

import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';
import 'package:usda_builder/usda_builder.dart';

import '../../helpers/fixtures.dart';

void main() {
  group('runUsdaBuilder', () {
    late Directory temp;
    late StringBuffer out;
    late StringBuffer err;

    setUp(() {
      temp = Directory.systemTemp.createTempSync('usda_builder_command');
      out = StringBuffer();
      err = StringBuffer();
    });
    tearDown(() => temp.deleteSync(recursive: true));

    Future<int> run(List<String> arguments) =>
        runUsdaBuilder(arguments, out: out, err: err);

    test('builds the file from the releases', () async {
      final output = '${temp.path}/usda_foods.sqlite';

      final code = await run([
        '--foundation',
        foundationFixture.path,
        '--sr-legacy',
        srLegacyFixture.path,
        '--output',
        output,
      ]);

      expect(code, 0);
      expect(out.toString(), contains('Wrote 5 foods, 10 portions'));
      final database = sqlite3.open(output, mode: OpenMode.readOnly);
      addTearDown(database.close);
      expect(database.select('SELECT id FROM foods'), hasLength(5));
    });

    test('prints help', () async {
      expect(await run(['--help']), 0);
      expect(out.toString(), contains('--sr-legacy'));
    });

    test('rejects missing options', () async {
      expect(await run(['--foundation', 'x']), usageExitCode);
      expect(err.toString(), contains('Missing --sr-legacy, --output.'));
    });

    test('rejects unknown options', () async {
      expect(await run(['--nope']), usageExitCode);
      expect(err.toString(), contains('nope'));
    });

    test('reports a release it cannot read', () async {
      final code = await run([
        '--foundation',
        '${temp.path}/missing',
        '--sr-legacy',
        srLegacyFixture.path,
        '--output',
        '${temp.path}/usda_foods.sqlite',
      ]);

      expect(code, failureExitCode);
      expect(err.toString(), contains('does not exist'));
    });
  });
}
