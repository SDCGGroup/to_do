import 'package:drift/drift.dart';

@DataClassName('Priority')
class Priorities extends Table {
  IntColumn get id => integer().autoIncrement()();

  Column get name => text()();

  IntColumn get level => integer()();
}
