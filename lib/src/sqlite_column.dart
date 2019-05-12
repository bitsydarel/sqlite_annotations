import 'package:meta/meta.dart';

enum ColumnType {
  INTEGER,
  REAL,
  TEXT,
  BLOB,
}

/// SQLite column definition.
/// Contains metadata about a column on a table.
class SQLiteColumn extends Object {
  /// Optional Name of the column.
  /// if null then the name of the field is used.
  final String name;

  /// Required type of data on the table column.
  final ColumnType type;

  /// Optional
  final bool primaryKey;

  @literal
  const SQLiteColumn(
    this.type, {
    this.name,
    this.primaryKey = false,
  }) : assert(type != null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SQLiteColumn &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type &&
          primaryKey == other.primaryKey;

  @override
  int get hashCode => name.hashCode ^ type.hashCode ^ primaryKey.hashCode;

  @override
  String toString() =>
      'SQLiteColumn{name: $name, type: $type, primaryKey: $primaryKey}';
}
