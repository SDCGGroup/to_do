import 'package:flutter/material.dart';
import 'package:to_do_app/presentation/pages/base_page.dart';
import 'package:to_do_app/presentation/views/loading.dart';
import 'package:to_do_app/routes/page_routes.dart';

class LoadingPage extends BasePage<void> {
  LoadingPage()
      : super(
          keyValue: InitialPageRoutes.loading,
          routeName: InitialPageRoutes.loading,
        );

  @override
  Route<void> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => const LoadingView(),
    );
  }
}
