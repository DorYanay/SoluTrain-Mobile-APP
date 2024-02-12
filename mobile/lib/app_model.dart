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
  coachPage,
  viewGroup,
}

class AppModel extends ChangeNotifier {
  // global data
  String? authToken;
  UserSchema? user;
  List<AreaSchema> areas;

  // pages navigation
  CurrentSinglePage currentPage = CurrentSinglePage.location;

  String currentPageGroupId = "";
  String currentPageViewGroupId = "";
  AreaSchema? currentPageArea;

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

  void moveToSearchGroupPage(AreaSchema area) {
    currentPage = CurrentSinglePage.searchGroups;
    currentPageArea = area;
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

  void moveToViewGroupPage(String groupId) {
    currentPage = CurrentSinglePage.viewGroup;
    currentPageViewGroupId = groupId;
    notifyListeners();
  }

  void moveToCreateMeetingPage(String groupId) {
    currentPage = CurrentSinglePage.createMeeting;
    currentPageGroupId = groupId;
    notifyListeners();
  }
}
