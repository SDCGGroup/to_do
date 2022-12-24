import 'package:routemaster/routemaster.dart';
import 'package:to_do_app/core/extensions/string.dart';
import 'package:to_do_app/presentation/pages/loading_page.dart';
import 'package:to_do_app/presentation/pages/not_found_page.dart';
import 'package:to_do_app/presentation/pages/task/task.dart';
import 'package:to_do_app/presentation/pages/task/task_list.dart';

/// Defines the base routing paths within the app.
///
/// Should generally be limited to the root pages of each [RouteMap].
class InitialPageRoutes {
  static const notFound = '/404';
  static const loading = '/loading';
  // initial routes
  static const root = '/';
}

/// Defines the available page route names.
///
/// Valid paths should be declared within the relevant [PageRoutes] value.
/// When [Routemaster.push] is invoked with a [RelativePageRoute], it
/// will be treated as a relative path to the current path, and push the
/// page on top.
///
/// Pushing a page with a leading `/` implies an absolute path, so this
/// will replace the current navigation stack with the new route path.
///
/// See [Routemaster.push] for more information.
class RelativePageRoutes {
  static const task = 'task';
}

class PageRoutes {
  /// Defines the primary routing map for init app.
  static final init = RouteMap(
    routes: {
      InitialPageRoutes.notFound: (routeData) => NotFoundPage(
            path: routeData.queryParameters['path'] ?? '',
          ),
      InitialPageRoutes.loading: (routeData) => LoadingPage(),
      InitialPageRoutes.root: (routeData) => TaskListPage(),

      //ToDoList/task/
      '/${RelativePageRoutes.task}/:${TaskPage.taskIdParam}': (routeData) {
        final taskId = _parseIntParam(
          routeData.pathParameters,
          TaskPage.taskIdParam,
        );
        return TaskPage(
          taskId: taskId ?? 0,
          keyValue: routeData.path,
          routeName: routeData.path,
        );
      },
    },
  );
  static int? _parseIntParam(Map<String, String> params, String paramName) {
    final value = params[paramName];
    return value?.intValue;
  }
}
