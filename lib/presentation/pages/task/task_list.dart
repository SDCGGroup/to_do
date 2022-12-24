import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/task/task_bloc.dart';
import 'package:to_do_app/presentation/pages/base_page.dart';
import 'package:to_do_app/presentation/views/task/task_list.dart';
import 'package:to_do_app/routes/page_routes.dart';

class TaskListPage extends BasePage<void> {
  TaskListPage({
    String keyValue = InitialPageRoutes.root,
    String routeName = InitialPageRoutes.root,
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
        create: (context) =>
            TaskBloc()..add(WatchTaskListEvent(sortingIndex: 0)),
        child: TaskListView(),
      ),
    );
  }
}
