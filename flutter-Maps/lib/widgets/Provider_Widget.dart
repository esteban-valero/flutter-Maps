import 'package:flashpark_client/Services/FirebaseServices.dart';
import 'package:flashpark_client/model/Address.dart';
import 'package:flashpark_client/widgets/appData.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final AuthService auth;
  final db;
  final AppData appData;

  Provider({Key key, Widget child, this.auth, this.db, this.appData})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context, {bool listen}) =>
      context.dependOnInheritedWidgetOfExactType<Provider>();
}
