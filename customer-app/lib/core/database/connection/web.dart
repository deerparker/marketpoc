import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor openConnection(String dbName) {
  return WebDatabase(dbName, logStatements: true);
}
