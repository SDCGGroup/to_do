import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routemaster/routemaster.dart';
import 'package:to_do_app/bloc/task/task_bloc.dart';
import 'package:to_do_app/core/extensions/string.dart';
import 'package:to_do_app/domain/entities/task.dart';
import 'package:to_do_app/presentation/widgets/error.dart';
import 'package:to_do_app/presentation/widgets/loading.dart';
import 'package:to_do_app/presentation/widgets/single_select_list.dart';

class TaskView extends StatefulWidget {
  const TaskView({
    Key? key,
  }) : super(key: key);

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  static const keyPrefix = 'TaskView';

  late final TextEditingController _txtNameController;
  late final TextEditingController _txtDescController;
  late int priorityId;

  @override
  void initState() {
    _txtNameController = TextEditingController();
    _txtDescController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _txtNameController.dispose();
    _txtDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            BlocConsumer<TaskBloc, TaskState>(
                listener: (context, state) {
                  if (state is TaskSaved) {
                    Routemaster.of(context).pop();
                  }
                },
                bloc: BlocProvider.of<TaskBloc>(context),
                builder: (context, state) {
                  if (state is LoadedTaskState) {
                    priorityId = state.task.priority;
                    _txtNameController.text = state.task.name;
                    _txtDescController.text = state.task.description ?? '';
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Builder(builder: (context) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child:
                                      new Image.asset('assets/images/todo.png'),
                                  height: 150,
                                  width: 150,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                                child: TextField(
                                  key: const Key('$keyPrefix-Name'),
                                  controller: _txtNameController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Name',
                                    // errorText: state.isValidName
                                    //     ? null
                                    //     : 'Value Can\'t Be Empty',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                                child: TextField(
                                  key: const Key('$keyPrefix-Description'),
                                  controller: _txtDescController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Description',
                                    // errorText: state.isValidDesc
                                    //     ? null
                                    //     : 'Value Can\'t Be Empty',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                                child: SingleSelectList(
                                  key: const Key('$keyPrefix-BtnLogin'),
                                  title: 'Priority Level',
                                  selectedOptionIndex: state.priorities
                                      .indexWhere((element) =>
                                          element.id == state.task.priority),
                                  optionsList: state.priorities
                                      .map((e) => e.name)
                                      .toList(growable: false),
                                  onTap: ((text) => priorityId = state
                                      .priorities
                                      .firstWhere(
                                          (element) => element.name == text)
                                      .id),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: ElevatedButton(
                                  key: const Key('$keyPrefix-BtnLogin'),
                                  child: Text(
                                      state.task.id != null ? "Update" : "Add"),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.fromLTRB(120, 10, 120, 10)),
                                  ),
                                  onPressed: () {
                                    if (_txtNameController
                                        .text.isNotNullNorEmpty) {
                                      if (state.task.id != null) {
                                        BlocProvider.of<TaskBloc>(context)
                                            .add(UpdateTaskEvent(
                                          task: TaskEntity(
                                            id: state.task.id,
                                            name: _txtNameController.text,
                                            description:
                                                _txtDescController.text,
                                            priority: priorityId,
                                            completed: state.task.completed,
                                          ),
                                        ));
                                      } else {
                                        BlocProvider.of<TaskBloc>(context)
                                            .add(AddTaskEvent(
                                          taskName: _txtNameController.text,
                                          taskDesc: _txtDescController.text,
                                          priorityId: priorityId,
                                          taskComplete: state.task.completed,
                                        ));
                                      }
                                    } else {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Invalid entry'),
                                            content: Text(
                                              'You can\'t add a task with an empty name ',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('Ok'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
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
          ]),
        ),
      ),
    );
  }
}
