import 'package:drift/drift.dart';

@DataClassName('Task')
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get description => text()();

  BoolColumn get completed => boolean()();

  IntColumn get priorityId =>
      integer().customConstraint('NOT NULL REFERENCES priorities(id)')();
}
