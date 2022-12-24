import 'package:moor/moor_web.dart';
import 'package:to_do_app/infrastructure/database/app_database.dart';

/// DO NOT import this directly, only import and init via `shared_interface.dart`.
Future<AppDatabase> constructDb({
  String dbName = 'db',
  bool logStatements = false,
}) async {
  return AppDatabase(
    WebDatabase.withStorage(
      await MoorWebStorage.indexedDbIfSupported(dbName),
      logStatements: logStatements,
    ),
  );
}
