import 'package:to_do_app/infrastructure/database/app_database.dart';

/// DO NOT import this directly, only import and init via `shared_interface.dart`.
Future<AppDatabase> constructDb({
  String? dbName,
}) {
  throw 'Platform not supported';
}
