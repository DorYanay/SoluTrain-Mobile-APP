import 'package:flutter/cupertino.dart';
import 'package:mobile/schemas.dart';

enum CurrentSinglePage {
  login,
  signUp,
  selectArea,
  myGroups,
  myMeetings,
  profile,
  searchGroups,
  viewGroup,
  viewMeeting,
  viewCoach,
  groups,
  createGroup,
  group,
  createMeeting,
  meeting,
  viewTrainer,
}

class AppModel extends ChangeNotifier {
  // global data
  String? authToken;
  UserSchema? user;
  List<AreaSchema> areas;

  // current displayed page
  CurrentSinglePage currentPage = CurrentSinglePage.login;

  // trainer pages data
  AreaSchema? currentPageArea;
  String? currentPageViewGroupId;
  bool currentPageViewGroupFromSearch = false; // come from SearchGroupsPage
  String? currentPageViewMeetingId;
  String? currentPageViewCoachId;

  // coach pages data
  String? currentPageGroupId;
  String? currentPageMeetingId;
  String? currentPageViewTrainerId;
  bool currentPageTrainerFromMeeting = false; // come from MeetingPage

  AppModel({this.areas = const <AreaSchema>[]});

  // getters
  bool get loggedIn => authToken != null;

  // change data
  void setLogin(LoginResponseSchema data) {
    authToken = data.authToken;
    user = data.user;
    areas = data.areas;

    moveToSelectAreaPage();

    notifyListeners();
  }

  void setUser(UserSchema updatedUser) {
    user = updatedUser;
    notifyListeners();
  }

  void setLogout() {
    authToken = null;
    user = null;
    areas = <AreaSchema>[];

    moveToLoginPage();

    notifyListeners();
  }

  // change current page
  void _cleanPagesData() {
    currentPageArea = null;
    currentPageViewGroupId = null;
    currentPageViewGroupFromSearch = false;
    currentPageViewMeetingId = null;
    currentPageViewCoachId = null;

    currentPageGroupId = null;
    currentPageMeetingId = null;
    currentPageViewTrainerId = null;
    currentPageTrainerFromMeeting = false;
  }

  void moveToLoginPage() {
    _cleanPagesData();

    currentPage = CurrentSinglePage.login;
    notifyListeners();
  }

  void moveToSignUpPage() {
    _cleanPagesData();

    currentPage = CurrentSinglePage.signUp;
    notifyListeners();
  }

  void moveToSelectAreaPage() {
    _cleanPagesData();

    currentPage = CurrentSinglePage.selectArea;
    notifyListeners();
  }

  void moveToMyGroupsPage() {
    _cleanPagesData();

    currentPage = CurrentSinglePage.myGroups;
    notifyListeners();
  }

  void moveToMyMeetingsPage() {
    _cleanPagesData();

    currentPage = CurrentSinglePage.myMeetings;
    notifyListeners();
  }

  void moveToProfilePage() {
    _cleanPagesData();

    currentPage = CurrentSinglePage.profile;

    notifyListeners();
  }

  void moveToSearchGroupPage(AreaSchema area) {
    currentPage = CurrentSinglePage.searchGroups;
    currentPageArea = area;

    notifyListeners();
  }

  void moveToViewGroupPage(String groupId, bool fromSearchGroups) {
    currentPage = CurrentSinglePage.viewGroup;
    currentPageViewGroupId = groupId;
    currentPageViewGroupFromSearch = fromSearchGroups;

    notifyListeners();
  }

  void moveToViewMeetingPage(String meetingId, String groupId) {
    currentPage = CurrentSinglePage.viewMeeting;
    currentPageViewMeetingId = meetingId;
    currentPageViewGroupId = groupId;

    notifyListeners();
  }

  void moveToViewCoachPage(String coachId, String groupId, String? meetingId) {
    currentPage = CurrentSinglePage.viewMeeting;
    currentPageViewCoachId = coachId;
    currentPageViewGroupId = groupId;
    currentPageViewMeetingId = meetingId;

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

  void moveToCreateMeetingPage(String groupId) {
    currentPage = CurrentSinglePage.createMeeting;
    currentPageGroupId = groupId;

    notifyListeners();
  }

  void moveToMeetingPage(String meetingId, String groupId) {
    currentPage = CurrentSinglePage.meeting;
    currentPageGroupId = groupId;
    currentPageMeetingId = meetingId;

    notifyListeners();
  }

  void moveToViewTrainerPage(
      String trainerId, String groupId, String? meetingId) {
    currentPage = CurrentSinglePage.createMeeting;
    currentPageViewTrainerId = trainerId;
    currentPageGroupId = groupId;
    currentPageMeetingId = meetingId;

    notifyListeners();
  }
}
