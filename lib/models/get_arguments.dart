import 'package:flutter/material.dart' show BuildContext, ModalRoute;

extension GetArgument on BuildContext {
  List? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        return args as List;
      }
    }
    return null;
  }
}
