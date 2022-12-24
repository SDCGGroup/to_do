import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:to_do_app/core/consts/app.dart';
import 'package:to_do_app/domain/repositories/task.dart';
import 'package:to_do_app/infrastructure/database/daos/task_dao.dart';
import 'package:to_do_app/infrastructure/database/platform/shared_interface.dart';

typedef AppRunner = FutureOr<void> Function();

class Injector {
  /// Initialises all app dependencies.
  ///
  /// Sentry is initialised before any dependencies are instantiated, to ensure
  /// that any potential errors can be caught as early as possible.
  ///
  /// [AppRunner] is called when everything is ready, at which point is when `runApp()`
  /// should be invoked.
  static Future<void> init({
    required AppRunner appRunner,
  }) async {
    await _initDependencies();
    appRunner();
  }

  /// Initialises all [GetIt] dependencies.
  static Future<void> _initDependencies() async {
    await _injectDatabase();
    _injectRepositories();

    await GetIt.I.allReady();
  }
}

/// Register database implementations.
///
/// Please ensure modifications are kept in alphabetical order (where possible) to ensure legibility.
Future<void> _injectDatabase() async {
  final db = await constructDb(
    dbName: AppConsts.databaseFilename,
  );
  GetIt.I.registerSingleton(db);
  GetIt.I.registerLazySingleton(() => TaskDao(db));
}

/// Register all repository implementations.
///
/// Please ensure modifications are kept in alphabetical order (where possible) to ensure legibility.
void _injectRepositories() {
  GetIt.I.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl());
}
