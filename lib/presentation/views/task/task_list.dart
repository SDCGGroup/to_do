import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routemaster/routemaster.dart';
import 'package:to_do_app/bloc/task/task_bloc.dart';
import 'package:to_do_app/domain/entities/task.dart';
import 'package:to_do_app/presentation/widgets/bottom_right_button.dart';
import 'package:to_do_app/presentation/widgets/cards/task_card.dart';
import 'package:to_do_app/presentation/widgets/error.dart';
import 'package:to_do_app/presentation/widgets/loading.dart';
import 'package:to_do_app/presentation/widgets/single_select_list.dart';
import 'package:to_do_app/routes/page_routes.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({Key? key}) : super(key: key);

  static const keyPrefix = 'TaskListView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TO DO list'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: new Image.asset('assets/images/todo_list.png'),
                      height: 150,
                      width: 150,
                    ),
                  ),
                  BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
                    if (state is LoadedTaskListState) {
                      final taskTotal = state.taskList.length;
                      final taskCompletedTotal = state.taskList
                          .where((element) => element.completed == true)
                          .length;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: SingleSelectList(
                                key: const Key('$keyPrefix-SortingList'),
                                title: 'Sort By',
                                selectedOptionIndex: state.sortingIndex,
                                optionsList: sortingTypes,
                                onTap: ((text) =>
                                    BlocProvider.of<TaskBloc>(context).add(
                                        WatchTaskListEvent(
                                            sortingIndex: state
                                                .sortingTypes
                                                .indexWhere((element) =>
                                                    element == text)))),
                              ),
                            ),
                            Text(
                                '$taskTotal task / $taskCompletedTotal completed'),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.taskList.length,
                              itemBuilder: (context, index) {
                                final task = state.taskList[index];
                                return TaskCard(
                                  key: ValueKey(
                                    '$keyPrefix-Card-${task.id}',
                                  ),
                                  id: task.id ?? 0,
                                  title: task.name,
                                  onDeletePressed: (id) {
                                    final taskBloc =
                                        BlocProvider.of<TaskBloc>(context);
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Delete task'),
                                          content: Text(
                                            'Are you sure, you want to delete the selected task',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                taskBloc.add(DeleteTaskEvent(
                                                  taskId: task.id ?? 0,
                                                ));
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  onEditPressed: (id) => Routemaster.of(context)
                                      .push('${RelativePageRoutes.task}/$id'),
                                  onPressed: (id) {
                                    final taskBloc =
                                        BlocProvider.of<TaskBloc>(context);

                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Update Task'),
                                          content: Text(
                                            'Are you sure, you want to complete/uncomplete the selected task?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                taskBloc.add(CompleteTaskEvent(
                                                  task: TaskEntity(
                                                    id: task.id,
                                                    name: task.name,
                                                    description:
                                                        task.description,
                                                    priority: task.priority,
                                                    completed: !task.completed,
                                                  ),
                                                ));
                                                Navigator.pop(context);
                                              },
                                              child: const Text('update'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  selected: task.completed,
                                );
                              },
                              separatorBuilder: (contex, index) {
                                return const SizedBox(height: 4);
                              },
                            ),
                          ],
                        ),
                      );
                    } else if (state is FailedTaskListState) {
                      return ErrorCardWidget(
                        key: const Key('$keyPrefix-ErrorCardWidget'),
                        message: state.message,
                        shouldRenderCard: false,
                      );
                    } else if (state is InitialTaskState) {
                      return LoadingWidget(
                        key: Key('$keyPrefix-LoadingView'),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                ],
              ),
            ),
            BottomRightButton(
              text: 'Add Task',
              icon: Icons.add_circle_outline,
              onPressed: () =>
                  Routemaster.of(context).push('${RelativePageRoutes.task}/0'),
            ),
          ],
        ),
      ),
    );
  }
}
