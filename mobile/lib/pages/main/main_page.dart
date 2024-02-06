import 'package:flutter/material.dart';
import 'package:mobile/widgets/bottom_nav_bar.dart';
import 'package:mobile/widgets/app_drawer.dart';
import 'package:mobile/pages/example/example_page.dart';
import 'package:mobile/pages/auth/auth_page.dart';
import 'package:provider/provider.dart';

import 'package:mobile/app_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages to display
  final List<Widget> _pages = [
    const ExamplePage(),
    const ExamplePage(),
    const ExamplePage(),
    const ExamplePage(),
  ];

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
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavBar(
            onTabChange: (index) => navigateBottomBar(index),
          ),
        );
      },
    );
  }
}
