import 'dart:io';

import 'package:test/test.dart';
import 'package:usda_builder/src/csv/csv_records.dart';

void main() {
  group('readCsvRecords', () {
    late Directory temp;

    setUp(() => temp = Directory.systemTemp.createTempSync('csv_records'));
    tearDown(() => temp.deleteSync(recursive: true));

    File write(String content) =>
        File('${temp.path}/table.csv')..writeAsStringSync(content);

    test('reads cells by column name, unquoting and trimming them', () async {
      final file = write(
        '"id","name"\n'
        '"1","Cheese, ""Swiss"", sliced"\n'
        '"2"," Broccoli "\n',
      );

      final records = await readCsvRecords(file, columns: {'id'}).toList();

      expect(records.map((r) => r['id']), ['1', '2']);
      expect(records.map((r) => r['name']), [
        'Cheese, "Swiss", sliced',
        'Broccoli',
      ]);
    });

    test('gives an empty string for a cell the row lacks', () async {
      final file = write('"id","name"\n"1"\n');

      final record = await readCsvRecords(file, columns: {}).single;

      expect(record['name'], isEmpty);
    });

    test('throws a FormatException naming missing columns', () {
      final file = write('"id"\n"1"\n');

      expect(
        readCsvRecords(file, columns: {'id', 'amount'}).toList(),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('amount'),
          ),
        ),
      );
    });

    test('throws an ArgumentError for a column not in the header', () async {
      final file = write('"id"\n"1"\n');

      final record = await readCsvRecords(file, columns: {}).single;

      expect(() => record['amount'], throwsArgumentError);
    });
  });
}
