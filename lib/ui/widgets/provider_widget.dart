import 'package:compound/services/authentication_service.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final AuthenticationService auth;

  Provider({Key key, Widget child, this.auth}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context, {bool listen}) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>());
}