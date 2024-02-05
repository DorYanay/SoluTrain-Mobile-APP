import 'package:flutter/cupertino.dart';

class AppModel extends ChangeNotifier {
  String? authToken;

  bool get loggedIn => authToken != null;

  void setAuthData(String authToken) {
    this.authToken = authToken;
    notifyListeners();
  }

  void removeAuthData() {
    authToken = null;
    notifyListeners();
  }
}
