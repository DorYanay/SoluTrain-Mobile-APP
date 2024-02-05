import 'package:flutter/material.dart';
import 'package:mobile/minimallogin/components/my_app_bar.dart';
import 'package:mobile/minimallogin/components/my_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const MyAppBar(
        title: "H O M E",
        actions: [],
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Text(
            "This is the home page of your app once the user logs in",
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
