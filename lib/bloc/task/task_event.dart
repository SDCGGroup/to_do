part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class WatchTaskListEvent extends TaskEvent {
  final int sortingIndex;
  const WatchTaskListEvent({
    required this.sortingIndex,
  });

  @override
  List<Object> get props => [
        sortingIndex,
      ];
}

class _UpdateTaskListEvent extends TaskEvent {
  const _UpdateTaskListEvent({
    required this.taskList,
    required this.sortingIndex,
  });

  final List<TaskEntity> taskList;
  final int sortingIndex;

  @override
  List<Object> get props => [
        taskList,
        sortingIndex,
      ];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;

  const UpdateTaskEvent({
    required this.task,
  });

  @override
  List<Object> get props => [
        task,
      ];
}

class CompleteTaskEvent extends TaskEvent {
  final TaskEntity task;

  const CompleteTaskEvent({
    required this.task,
  });

  @override
  List<Object> get props => [
        task,
      ];
}

class DeleteTaskEvent extends TaskEvent {
  final int taskId;

  const DeleteTaskEvent({
    required this.taskId,
  });

  @override
  List<Object> get props => [
        taskId,
      ];
}

class GetTaskEvent extends TaskEvent {
  final int taskId;
  const GetTaskEvent({
    required this.taskId,
  });

  @override
  List<Object> get props => [taskId];
}

class AddTaskEvent extends TaskEvent {
  final String taskName;
  final String? taskDesc;
  final int priorityId;
  final bool taskComplete;
  const AddTaskEvent({
    required this.taskName,
    this.taskDesc,
    required this.priorityId,
    required this.taskComplete,
  });

  @override
  List<Object?> get props => [
        taskName,
        taskDesc,
        priorityId,
        taskComplete,
      ];
}
