import 'package:flutter/material.dart';
import 'package:mobile/pages/groups/groups_page.dart';
import 'package:mobile/pages/profile/coach_profile_page.dart';
import 'package:mobile/pages/profile/trainer_profile_page.dart';
import 'package:provider/provider.dart';

import 'package:mobile/app_model.dart';
import 'package:mobile/pages/my_groups/my_group_page.dart';
import 'package:mobile/pages/location/location_page.dart';
import 'package:mobile/pages/my_meetings/my_meetings_page.dart';
import 'package:mobile/widgets/app_bottom_nav_bar.dart';
import 'package:mobile/widgets/app_drawer.dart';
import 'package:mobile/pages/auth/auth_page.dart';

import 'package:mobile/pages/groups/create_group_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void navigateBottomBar(int index) {
    if (index == 0) {
      Provider.of<AppModel>(context, listen: false).moveToLocationPage();
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
      case CurrentSinglePage.location:
        return const LocationPage();
      case CurrentSinglePage.myGroups:
        return const MyGroupsPage();
      case CurrentSinglePage.myMeetings:
        return const MyMeetingsPage();
      case CurrentSinglePage.profile:
        if (appModel.user!.isCoach) {
          return const CoachProfilePage();
        }
        return const TrainerProfilePage();
      case CurrentSinglePage.groups:
        return const GroupsPage();
      case CurrentSinglePage.createGroup:
        return const CreateGroupPage();
      case CurrentSinglePage.group:
        return const GroupsPage();
      case CurrentSinglePage.createMeeting:
        return const LocationPage();
      case CurrentSinglePage.meeting:
        return const LocationPage();
      case CurrentSinglePage.searchGroups:
        return const LocationPage();
      case CurrentSinglePage.coachPage:
        return const LocationPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (BuildContext context, AppModel appModel, Widget? widget) {
        if (!appModel.loggedIn) {
          return const AuthPage();
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
                onPressed: () => Scaffold.of(context).openDrawer(),
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
            onTabChange: (index) => navigateBottomBar(index),
          ),
        );
      },
    );
  }
}
