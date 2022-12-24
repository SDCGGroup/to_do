import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:to_do_app/core/consts/app.dart';
import 'package:to_do_app/domain/entities/priority.dart';
import 'package:to_do_app/domain/entities/task.dart';
import 'package:to_do_app/domain/repositories/task.dart';

part 'task_event.dart';
part 'task_state.dart';

final sortingTypes = ['id', 'name', 'priority'];

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(const InitialTaskState()) {
    on<WatchTaskListEvent>(_onWatchTaskListEvent);
    on<_UpdateTaskListEvent>(_onUpdateTaskListEvent);
    on<GetTaskEvent>(_onGetTaskEvent);
    on<AddTaskEvent>(_onAddTaskEvent);
    on<UpdateTaskEvent>(_onUpdateTaskEvent);
    on<CompleteTaskEvent>(_onCompleteTaskEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
  }

  final _taskRepo = GetIt.I<TaskRepository>();
  StreamSubscription<List<TaskEntity>>? _taskListStream;

  @override
  Future<void> close() async {
    await _taskListStream?.cancel();
    return super.close();
  }

  Future<FutureOr<void>> _onWatchTaskListEvent(
    WatchTaskListEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      // cancel
      await _taskListStream?.cancel();

      final stream =
          _taskRepo.getTaskList(sortedBy: sortingTypes[event.sortingIndex]);

      _taskListStream = stream.listen((taskList) {
        add(_UpdateTaskListEvent(
          taskList: taskList,
          sortingIndex: event.sortingIndex,
        ));
      });
    } catch (err, stack) {
      logError(err, stacktrace: stack);
      const message = AppConsts.unavailableContent;
      emit(const FailedTaskListState(message: message));
    }
  }

  Future<FutureOr<void>> _onUpdateTaskListEvent(
    _UpdateTaskListEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      emit(LoadedTaskListState(
        taskList: event.taskList,
        sortingTypes: sortingTypes,
        sortingIndex: event.sortingIndex,
      ));
    } catch (err, stack) {
      logError(err, stacktrace: stack);
      const message = AppConsts.unavailableContent;
      emit(const FailedTaskListState(message: message));
    }
  }

  Future<void> _onGetTaskEvent(
    GetTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final prioritiesList = await _taskRepo.getPriorities();
      final emptyTask = TaskEntity(name: '', priority: 1, completed: false);
      final task = event.taskId != 0
          ? await _taskRepo.getTaskById(taskId: event.taskId)
          : emptyTask;
      emit(LoadedTaskState(
        task: task ?? emptyTask,
        priorities: prioritiesList,
      ));
    } catch (err, stack) {
      logError(err, stacktrace: stack);
      const message = AppConsts.unavailableContent;
      emit(const FailedTaskState(message: message));
    }
  }

  Future<void> _onAddTaskEvent(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepo.saveTask(
        task: TaskEntity(
          name: event.taskName,
          description: event.taskDesc,
          priority: event.priorityId,
          completed: event.taskComplete,
        ),
      );
      emit(TaskSaved());
    } catch (err, stack) {
      logError(err, stacktrace: stack);
      const message = 'task add failed';
      emit(const FailedTaskState(message: message));
    }
  }

  Future<void> _onUpdateTaskEvent(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepo.updateTask(
        task: event.task,
      );
      emit(TaskSaved());
    } catch (err, stack) {
      logError(err, stacktrace: stack);
      const message = 'task update failed';
      emit(const FailedTaskState(message: message));
    }
  }

  Future<void> _onCompleteTaskEvent(
    CompleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepo.updateTask(
        task: event.task,
      );
    } catch (err, stack) {
      logError(err, stacktrace: stack);
      const message = 'task update failed';
      emit(const FailedTaskState(message: message));
    }
  }

  Future<void> _onDeleteTaskEvent(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await _taskRepo.deleteTask(
        taskId: event.taskId,
      );
    } catch (err, stack) {
      logError(err, stacktrace: stack);
      const message = 'task update failed';
      emit(const FailedTaskState(message: message));
    }
  }
}
