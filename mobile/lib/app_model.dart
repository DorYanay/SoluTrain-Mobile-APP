import 'package:flutter/cupertino.dart';
import 'package:mobile/schemas.dart';

class AppModel extends ChangeNotifier {
  String? authToken;
  UserSchema? user;

  List<AreaSchema> areas;

  AppModel({this.areas = const <AreaSchema>[]});

  bool get loggedIn => authToken != null;

  void setLogin(LoginResponseSchema data) {
    authToken = data.authToken;
    user = data.user;

    areas = data.areas;

    notifyListeners();
  }

  void setLogout() {
    authToken = null;
    user = null;

    notifyListeners();
  }
}
