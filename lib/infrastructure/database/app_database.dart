import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:moor/moor.dart';
import 'package:to_do_app/infrastructure/database/daos/task_dao.dart';
import 'package:to_do_app/infrastructure/database/models/priority.dart';
import 'package:to_do_app/infrastructure/database/models/tasks.dart';

part 'app_database.g.dart';

@UseMoor(tables: [
  Tasks,
  Priorities,
], daos: [
  TaskDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
        onCreate: (migrator) async {
          // Create database tables.
          await migrator.createAll();
          await importSql('assets/db/seed.sql');
        },
        onUpgrade: (m, from, to) async {},
      );
  Future<void> importSql(String sqlPath) async {
    final initialData = await rootBundle.loadString(sqlPath);

    await transaction(() async {
      // hopefully you're not using ; anywhere else in your SQL besides ending statements
      for (final data in initialData.split(';')) {
        if (data.trim().isNotEmpty) {
          await customStatement(data);
        }
      }
    });
  }
}
