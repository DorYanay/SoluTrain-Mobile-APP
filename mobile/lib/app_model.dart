import 'package:flutter/cupertino.dart';
import 'package:mobile/schemas.dart';

enum CurrentSinglePage {
  location,
  myGroups,
  myMeetings,
  profile,
  groups,
  createGroup,
  group,
  createMeeting,
  meeting,
  searchGroups,
  coachPage
}

class AppModel extends ChangeNotifier {
  // global data
  String? authToken;
  UserSchema? user;
  List<AreaSchema> areas;

  // pages navigation
  CurrentSinglePage currentPage = CurrentSinglePage.location;

  String currentPageGroupId = "";

  AppModel({this.areas = const <AreaSchema>[]});

  bool get loggedIn => authToken != null;

  void setLogin(LoginResponseSchema data) {
    authToken = data.authToken;
    user = data.user;
    areas = data.areas;

    moveToLocationPage();

    notifyListeners();
  }

  void setLogout() {
    authToken = null;
    user = null;

    moveToLocationPage();

    notifyListeners();
  }

  void moveToLocationPage() {
    currentPage = CurrentSinglePage.location;
    notifyListeners();
  }

  void moveToMyGroupsPage() {
    currentPage = CurrentSinglePage.myGroups;
    notifyListeners();
  }

  void moveToMyMeetingsPage() {
    currentPage = CurrentSinglePage.myMeetings;
    notifyListeners();
  }

  void moveToProfilePage() {
    currentPage = CurrentSinglePage.profile;
    notifyListeners();
  }

  void moveToGroupsPage() {
    currentPage = CurrentSinglePage.groups;
    notifyListeners();
  }

  void moveToCreateGroupPage() {
    currentPage = CurrentSinglePage.createGroup;
    notifyListeners();
  }

  void moveToGroupPage(String groupId) {
    currentPage = CurrentSinglePage.group;
    currentPageGroupId = groupId;
    notifyListeners();
  }
}
