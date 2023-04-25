import 'package:flutter/material.dart';
import 'register_page.dart';
import 'login_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {

  //initially show a login page at the beginning
  bool showLoginPage = true;

  // a method to toggle between the login and the register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(
        onTap: togglePages,
      );
    }
    else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
