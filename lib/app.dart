import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';
import 'package:to_do_app/core/consts/app.dart';
import 'package:to_do_app/core/utils/injector.dart';
import 'package:to_do_app/routes/page_routes.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Injector.init(
    appRunner: () => runApp(App()),
  );
}

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late final RoutemasterDelegate routemaster;

  @override
  void initState() {
    routemaster = RoutemasterDelegate(
      routesBuilder: (context) {
        return PageRoutes.init;
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: ObjectKey('init'),
      title: AppConsts.appName,
      routeInformationParser: const RoutemasterParser(),
      routerDelegate: routemaster,
      builder: (context, child) => MediaQuery(
        // override OS-level font scaling
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
