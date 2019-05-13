import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sqlite_statements/sqlite_statements.dart';

class SQLiteColumnElement {
  final FieldElement _columnInfo;
  final SQLiteColumn _columnAnnotation;

  @literal
  const SQLiteColumnElement(this._columnInfo, this._columnAnnotation);

  String toColumnDefinition(final List<Error> errorHolder) {
    if (_columnAnnotation.type == null) {
      final columnWithoutTypeError = StateError(
        "Column with name $columnName does not have a type",
      );

      log.severe(
        columnWithoutTypeError.message,
        columnWithoutTypeError,
        StackTrace.current,
      );

      errorHolder.add(columnWithoutTypeError);
    }

    final String notNull = _columnAnnotation.primaryKey ? " NOT NULL" : "";

    return "$columnName $columnType$notNull";
  }

  bool get isPrimaryKey => _columnAnnotation.primaryKey;

  String get columnName => _columnAnnotation.name ?? _columnInfo.displayName;

  String get columnType => _columnAnnotation.type.toString().split('.')[1];

  static SQLiteColumn findColumnAnnotation(final FieldElement field) {
    final annotation = const TypeChecker.fromRuntime(SQLiteColumn)
        .firstAnnotationOfExact(field, throwOnUnresolved: false);

    if (annotation == null) {
      return null;
    } else {
      final columnTypeValue = ColumnType.values.firstWhere(
        (columnType) =>
            annotation
                .getField("type")
                .getField(columnType.toString().split('.')[1]) !=
            null,
        orElse: () => null,
      );

      return SQLiteColumn(
        columnTypeValue,
        name: annotation.getField("name").toStringValue(),
        primaryKey: annotation.getField("primaryKey").toBoolValue(),
      );
    }
  }

  static bool containsInvalidSqliteColumns(final List<FieldElement> fields) {
    return fields.any(
      (field) {
        return field.metadata.any(
          (annotation) => annotation.computeConstantValue() == null,
        );
      },
    );
  }
}
