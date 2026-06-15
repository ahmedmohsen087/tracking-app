import 'package:flowery_driver_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text(AppStrings.routeNotFound))),
        );
    }
  }
}
