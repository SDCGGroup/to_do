import 'package:equatable/equatable.dart';

class PriorityEntity extends Equatable {
  final int id;
  final String name;
  final int level;

  PriorityEntity({
    required this.id,
    required this.name,
    required this.level,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        level,
      ];

  @override
  String toString() {
    return '''PriorityEntity(
        id: $id,
        name: $name,
        level: $level,
    )''';
  }

  PriorityEntity copyWith({
    int? id,
    String? name,
    int? level,
  }) {
    return PriorityEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
    );
  }
}
