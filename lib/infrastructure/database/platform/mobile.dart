import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as paths;
import 'package:to_do_app/infrastructure/database/app_database.dart';

/// DO NOT import this directly, only import and init via `shared_interface.dart`.
Future<AppDatabase> constructDb({
  String dbName = 'db',
  bool logStatements = false,
}) async {
  if (Platform.isIOS || Platform.isAndroid) {
    final executor = LazyDatabase(() async {
      final dataDir = await paths.getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dataDir.path, '$dbName.sqlite'));
      return VmDatabase(dbFile, logStatements: logStatements);
    });
    return AppDatabase(executor);
  }
  if (Platform.isMacOS || Platform.isLinux) {
    final file = File('db.sqlite');
    return AppDatabase(VmDatabase(file, logStatements: logStatements));
  }
  return AppDatabase(VmDatabase.memory(logStatements: logStatements));
}
