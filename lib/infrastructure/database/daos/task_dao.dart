import 'dart:async';

import 'package:moor/moor.dart';
import 'package:to_do_app/domain/entities/priority.dart';
import 'package:to_do_app/domain/entities/task.dart';
import 'package:to_do_app/infrastructure/database/app_database.dart';
import 'package:to_do_app/infrastructure/database/models/priority.dart';
import 'package:to_do_app/infrastructure/database/models/tasks.dart';

part 'task_dao.g.dart';

@UseDao(tables: [
  Tasks,
  Priorities,
])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(AppDatabase appDb) : super(appDb);

// Gets all tasks
  Stream<List<TaskEntity>> getTaskList({
    required String? sortedBy,
  }) {
    var orderBy;
    switch (sortedBy) {
      case 'priority':
        orderBy = [OrderingTerm.asc(priorities.level)];
        break;
      case 'name':
        orderBy = [OrderingTerm.asc(tasks.name)];
        break;
      default:
        orderBy = [OrderingTerm.asc(tasks.id)];
        break;
    }
    ;
    return (select(tasks).join(
            [innerJoin(priorities, priorities.id.equalsExp(tasks.priorityId))])
          ..orderBy(orderBy))
        .watch()
        .transform(StreamTransformer.fromHandlers(handleData: (data, sink) {
      final transformedData = data
          .map(
            (e) => TaskEntity(
              id: e.readTable(tasks).id,
              name: e.readTable(tasks).name,
              description: e.readTable(tasks).description,
              completed: e.readTable(tasks).completed,
              priority: e.readTable(priorities).level,
            ),
          )
          .toList();
      sink.add(transformedData);
    }));
  }

  Future<List<PriorityEntity>> getPriorities() => select(priorities)
      .map(
        (p) => PriorityEntity(
          id: p.id,
          name: p.name,
          level: p.level,
        ),
      )
      .get();

  Future<TaskEntity?> getTaskById({required int taskId}) => (select(tasks).join(
          [innerJoin(priorities, priorities.id.equalsExp(tasks.priorityId))])
        ..where(tasks.id.equals(taskId))
        ..orderBy([OrderingTerm.desc(tasks.id)])
        ..limit(1))
      .map(
        (e) => TaskEntity(
          id: e.readTable(tasks).id,
          name: e.readTable(tasks).name,
          description: e.readTable(tasks).description,
          completed: e.readTable(tasks).completed,
          priority: e.readTable(priorities).level,
        ),
      )
      .getSingleOrNull();

  // Save task
  Future<void> saveTask({required TaskEntity task}) async {
    await into(tasks).insertOnConflictUpdate(
      TasksCompanion(
        name: Value<String>(task.name),
        description: Value<String>(task.description ?? ''),
        priorityId: Value<int>(task.priority),
        completed: Value<bool>(task.completed),
      ),
    );
  }

  // update task
  Future<void> updateTask({required TaskEntity task}) async {
    await (update(tasks)..where((data) => data.id.equals(task.id)))
        .write(TasksCompanion(
      name: Value<String>(task.name),
      description: Value<String>(task.description ?? ''),
      priorityId: Value<int>(task.priority),
      completed: Value<bool>(task.completed),
    ));
  }

// delete selected task
  Future<void> deleteTask({
    required int taskId,
  }) {
    final query = delete(tasks);
    query.where((row) => row.id.equals(taskId));
    return query.go();
  }
}
