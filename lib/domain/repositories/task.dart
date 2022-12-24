import 'package:get_it/get_it.dart';
import 'package:to_do_app/domain/entities/priority.dart';
import 'package:to_do_app/domain/entities/task.dart';
import 'package:to_do_app/infrastructure/database/daos/task_dao.dart';

abstract class TaskRepository<T extends TaskEntity, K extends PriorityEntity> {
  Stream<List<T>> getTaskList({required String? sortedBy});
  Future<List<K>> getPriorities();
  Future<T?> getTaskById({required int taskId});
  Future<void> saveTask({required T task});
  Future<void> updateTask({required T task});
  Future<void> deleteTask({required int taskId});
}

class TaskRepositoryImpl extends TaskRepository {
  final _taskDao = GetIt.I<TaskDao>();

  // Get all Tasks
  @override
  Stream<List<TaskEntity>> getTaskList({required String? sortedBy}) =>
      _taskDao.getTaskList(
        sortedBy: sortedBy,
      );

  /// Gets all priorities
  @override
  Future<List<PriorityEntity>> getPriorities() async =>
      _taskDao.getPriorities();

  /// Gets task by id
  @override
  Future<TaskEntity?> getTaskById({required int taskId}) async =>
      _taskDao.getTaskById(taskId: taskId);

  /// delete task by id
  @override
  Future<void> deleteTask({required int taskId}) async =>
      _taskDao.deleteTask(taskId: taskId);

  /// save task
  @override
  Future<void> saveTask({required TaskEntity task}) async =>
      await _taskDao.saveTask(task: task);

  /// update task
  @override
  Future<void> updateTask({required TaskEntity task}) async =>
      await _taskDao.updateTask(task: task);
}
