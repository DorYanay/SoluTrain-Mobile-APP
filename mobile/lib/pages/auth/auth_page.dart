import 'package:flutter/material.dart';
import 'package:mobile/pages/auth/login_page.dart';
import 'package:mobile/pages/auth/sign_up_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void showLogin() {
    setState(() {
      showLoginPage = true;
    });
  }

  void showSighUp() {
    setState(() {
      showLoginPage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        showSighUp: showSighUp,
      );
    } else {
      return SighUpPage(
        showLogin: showLogin,
      );
    }
  }
}
