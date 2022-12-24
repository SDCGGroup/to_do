import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final int? id;
  final String name;
  final String? description;
  final bool completed;
  final int priority;

  TaskEntity({
    this.id,
    required this.name,
    this.description,
    this.completed = false,
    required this.priority,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        completed,
        priority,
      ];

  @override
  String toString() {
    return '''TaskEntity(
        id: $id,
        name: $name,
        description: $description,
        completed: $completed,
        priority: $priority,
    )''';
  }

  TaskEntity copyWith({
    int? id,
    String? name,
    String? description,
    bool? completed,
    int? priority,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
    );
  }
}
