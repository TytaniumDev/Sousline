import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';

/// One row of a CSV file, read by column name.
final class const CsvRecord._(
  final Map<String, int> _columns,
  final List<dynamic> _cells,
) {
  /// The text in [column], trimmed. Empty when the row has no such cell.
  ///
  /// Throws an [ArgumentError] when the file has no such column, which is a
  /// programming error: [readCsvRecords] already checked the header.
  String operator [](String column) {
    final index = _columns[column];
    if (index == null) {
      throw ArgumentError.value(column, 'column', 'is not in the header');
    }
    return index < _cells.length ? '${_cells[index]}'.trim() : '';
  }
}

/// Reads [file] as CSV with a header row, one [CsvRecord] per data row.
///
/// Throws a [FormatException] when the header lacks any of [columns], so a
/// changed release format fails loudly instead of producing empty values.
Stream<CsvRecord> readCsvRecords(
  File file, {
  required Set<String> columns,
}) async* {
  Map<String, int>? header;
  final rows = file
      .openRead()
      .transform(utf8.decoder)
      .transform(const CsvDecoder());
  await for (final row in rows) {
    if (header == null) {
      header = {for (final (index, name) in row.indexed) '$name'.trim(): index};
      final missing = columns.difference(header.keys.toSet());
      if (missing.isNotEmpty) {
        throw FormatException(
          '${file.path} is missing the columns ${missing.join(', ')}',
        );
      }
      continue;
    }
    yield CsvRecord._(header, row);
  }
}
