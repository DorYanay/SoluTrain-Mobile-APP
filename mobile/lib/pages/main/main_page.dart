import 'package:flutter/material.dart';
import 'package:mobile/pages/create_group/create_group_page.dart';
import 'package:mobile/pages/create_meeting/create_meeting_page.dart';
import 'package:mobile/pages/group/group_page.dart';
import 'package:mobile/pages/groups/groups_page.dart';
import 'package:mobile/pages/meeting/meeting_page.dart';
import 'package:mobile/pages/my_groups/my_groups_page.dart';
import 'package:mobile/pages/my_meetings/my_meetings_page.dart';
import 'package:mobile/pages/profile/coach_profile_page.dart';
import 'package:mobile/pages/profile/trainer_profile_page.dart';
import 'package:mobile/pages/search_groups/search_groups_page.dart';
import 'package:mobile/pages/select_area/select_area_page.dart';
import 'package:mobile/pages/view_coach/view_coach_page.dart';
import 'package:mobile/pages/view_group/view_group_page.dart';
import 'package:mobile/pages/view_meeting/view_meeting_page.dart';
import 'package:mobile/pages/view_trainer/view_trainer_page.dart';
import 'package:provider/provider.dart';

import 'package:mobile/app_model.dart';
import 'package:mobile/widgets/app_bottom_nav_bar.dart';
import 'package:mobile/widgets/app_drawer.dart';
import 'package:mobile/pages/login/login_page.dart';
import 'package:mobile/pages/sign_up/sign_up_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void navigateBottomBar(int index) {
    if (index == 0) {
      Provider.of<AppModel>(context, listen: false).moveToSelectAreaPage();
    } else if (index == 1) {
      Provider.of<AppModel>(context, listen: false).moveToMyGroupsPage();
    } else if (index == 2) {
      Provider.of<AppModel>(context, listen: false).moveToMyMeetingsPage();
    } else {
      Provider.of<AppModel>(context, listen: false).moveToProfilePage();
    }
  }

  Widget getCurrentPage(AppModel appModel) {
    switch (appModel.currentPage) {
      case CurrentSinglePage.login:
        return const LoginPage();
      case CurrentSinglePage.signUp:
        return const SighUpPage();
      case CurrentSinglePage.selectArea:
        return const SelectAreaPage();
      case CurrentSinglePage.myGroups:
        return const MyGroupsPage();
      case CurrentSinglePage.myMeetings:
        return const MyMeetingsPage();
      case CurrentSinglePage.profile:
        if (appModel.user!.isCoach) {
          return const CoachProfilePage();
        }
        return const TrainerProfilePage();
      case CurrentSinglePage.searchGroups:
        return SearchGroupsPage(appModel.currentPageArea!);
      case CurrentSinglePage.viewGroup:
        return ViewGroupPage(appModel.currentPageViewGroupId!,
            appModel.currentPageViewGroupFromSearch);
      case CurrentSinglePage.viewMeeting:
        return ViewMeetingPage(appModel.currentPageViewMeetingId!,
            appModel.currentPageViewGroupId!);
      case CurrentSinglePage.viewCoach:
        return ViewCoachPage(
            appModel.currentPageViewCoachId!,
            appModel.currentPageViewGroupId!,
            appModel.currentPageViewMeetingId);
      case CurrentSinglePage.groups:
        return const GroupsPage();
      case CurrentSinglePage.createGroup:
        return const CreateGroupPage();
      case CurrentSinglePage.group:
        return GroupPage(appModel.currentPageGroupId!);
      case CurrentSinglePage.createMeeting:
        return CreateMeetingPage(appModel.currentPageGroupId!);
      case CurrentSinglePage.meeting:
        return MeetingPage(
            appModel.currentPageMeetingId!, appModel.currentPageGroupId!);
      case CurrentSinglePage.viewTrainer:
        return ViewTrainerPage(appModel.currentPageViewTrainerId!,
            appModel.currentPageGroupId!, appModel.currentPageMeetingId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (BuildContext context, AppModel appModel, Widget? widget) {
        if (!appModel.loggedIn) {
          return getCurrentPage(appModel);
        }

        return Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.grey.shade800,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            title: Text(
              'SoluTrain',
              style: TextStyle(color: Colors.grey.shade800),
            ),
          ),
          drawer: const AppDrawer(),
          body: getCurrentPage(appModel),
          bottomNavigationBar: AppBottomNavBar(
            onTabChange: (index) {
              navigateBottomBar(index);
            },
          ),
        );
      },
    );
  }
}
