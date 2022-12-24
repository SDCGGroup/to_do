part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class InitialTaskState extends TaskState {
  const InitialTaskState();
}

class LoadedTaskListState extends TaskState {
  const LoadedTaskListState({
    required this.taskList,
    required this.sortingTypes,
    required this.sortingIndex,
  });

  final List<TaskEntity> taskList;
  final List<String> sortingTypes;
  final int sortingIndex;

  @override
  List<Object?> get props => [
        taskList,
        sortingTypes,
        sortingIndex,
      ];
}

class LoadedTaskState extends TaskState {
  const LoadedTaskState({
    required this.task,
    required this.priorities,
  });

  final TaskEntity task;
  final List<PriorityEntity> priorities;

  @override
  List<Object?> get props => [
        task,
        priorities,
      ];
}

class TaskSaved extends TaskState {
  const TaskSaved();
}

class FailedTaskListState extends TaskState {
  const FailedTaskListState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class FailedTaskState extends TaskState {
  const FailedTaskState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
