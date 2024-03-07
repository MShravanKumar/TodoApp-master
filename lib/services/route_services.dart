import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/view/view.dart';

class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    // final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case '/homepage':
        return CupertinoPageRoute(builder: (_) {
          return const TodoListScreen();
        });

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Page Not Found"),
        ),
      );
    });
  }
}
