/// SQLite table metadata.
///
/// Specify how a SQLite table information should be generated.
class SQLiteTable {
  /// Name of the table.
  final String name;

  /// [bool] if true, the generator will generate method
  /// to represent the structure of the table.
  final bool createToTableStatement;

  /// [bool] if true, the generator will generate method
  /// for insert statement.
  final bool generateInsertStatement;

  /// [bool] if true, the generator will generate method
  /// for update statement.
  final bool generateUpdateStatement;

  /// [bool] if true, the generator will generate method
  /// for delete statement.
  final bool generateDeleteStatement;

  const SQLiteTable({
    this.name,
    this.createToTableStatement = true,
    this.generateInsertStatement = false,
    this.generateUpdateStatement = false,
    this.generateDeleteStatement = false,
  });
}
