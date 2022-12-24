import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/task/task_bloc.dart';
import 'package:to_do_app/presentation/pages/base_page.dart';
import 'package:to_do_app/presentation/views/task/task_view.dart';
import 'package:to_do_app/routes/page_routes.dart';

class TaskPage extends BasePage<void> {
  static const taskIdParam = 'taskId';
  final int taskId;

  TaskPage({
    required this.taskId,
    String keyValue = RelativePageRoutes.task,
    String routeName = RelativePageRoutes.task,
    Map<String, dynamic> arguments = const <String, dynamic>{},
  }) : super(
          keyValue: keyValue,
          routeName: routeName,
          arguments: arguments,
        );

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => BlocProvider<TaskBloc>(
        create: (context) => TaskBloc()..add(GetTaskEvent(taskId: taskId)),
        child: TaskView(),
      ),
    );
  }
}
