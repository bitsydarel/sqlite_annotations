import 'dart:async';

import 'package:build/build.dart';
import 'package:meta/meta.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sqlite_statements_generator/src/sqlite_column_element.dart';

class SQLiteTableElement {
  final ClassElement _tableInfo;
  final ConstantReader _tableAnnotation;
  final List<Error> _containsErrors;

  const SQLiteTableElement(
    this._tableInfo,
    this._tableAnnotation,
    this._containsErrors,
  );

  FutureOr<String> toClass() {
    final generatedClass = Class((builder) => createTableClass(builder));

    final emitter = DartEmitter();

    return generatedClass.accept(emitter).toString();
  }

  bool hasError() => _containsErrors.isNotEmpty;

  @visibleForTesting
  void createTableClass(final ClassBuilder classBuilder) {
    classBuilder.name = "\$${_tableInfo.displayName}";

    final List<SQLiteColumnElement> columns = _tableInfo.fields.isNotEmpty
        ? getColumnFields(_tableInfo.fields)
        : <SQLiteColumnElement>[];

    if (_tableAnnotation.read("createToTableStatement").boolValue == true) {
      classBuilder.methods.add(
        buildToTable(columns),
      );
    }

    if (_tableAnnotation.read("generateInsertStatement").boolValue == true) {
      //TODO implement generate Insert Statement.
    }

    if (_tableAnnotation.read("generateUpdateStatement").boolValue == true) {
      //TODO implement generate update statement
    }

    if (_tableAnnotation.read("generateDeleteStatement").boolValue == true) {
      //TODO implement generate delete statement.
    }
  }

  @visibleForTesting
  List<SQLiteColumnElement> getColumnFields(final List<FieldElement> fields) =>
      fields
          .where((field) =>
              SQLiteColumnElement.findColumnAnnotation(field) != null)
          .map(
            (field) => SQLiteColumnElement(
                  field,
                  SQLiteColumnElement.findColumnAnnotation(field),
                ),
          )
          .toList(growable: false);

  @visibleForTesting
  Method buildToTable(final List<SQLiteColumnElement> columns) {
    final StringBuffer template = StringBuffer();

    final String tableName =
        _tableAnnotation.read("name").literalValue ?? _tableInfo.displayName;

    template.write("CREATE TABLE IF NOT EXISTS $tableName");

    final String columnsDefinitions = columns
        .map((column) => column.toColumnDefinition(_containsErrors))
        .join(", ");

    if (columnsDefinitions.isNotEmpty) {
      template.write(" $columnsDefinitions");
    }

    final String primaryKeysDefinitions =
        generatePrimaryKeysDefinitions(columns);

    if (primaryKeysDefinitions.isNotEmpty) {
      template.write(" $primaryKeysDefinitions");
    }

    final method = MethodBuilder()
      ..static = true
      ..name = "toTableStatement"
      ..body = Code("return \"${template.toString()}\";")
      ..returns = Reference("String");

    return method.build();
  }

  @visibleForTesting
  String generatePrimaryKeysDefinitions(
    final List<SQLiteColumnElement> columns,
  ) {
    final primaryColumns = columns
        .where((column) => column.isPrimaryKey)
        .map((column) => column.columnName)
        .join(", ");

    if (primaryColumns?.isEmpty == true) {
      final missingPrimaryKeyError = StateError(
        "No Column defined as Primary Key${primaryColumns.isNotEmpty ? ", columns: $primaryColumns" : ""}",
      );

      log.severe(
        missingPrimaryKeyError.message,
        missingPrimaryKeyError,
        StackTrace.current,
      );

      _containsErrors.add(missingPrimaryKeyError);
    }

    return "PRIMARY KEY ($primaryColumns)";
  }
}
