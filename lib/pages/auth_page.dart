import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/pages/login.dart';

import 'home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
         // If User is logged in
          if (snapshot.hasData) {
            return const HomePage();
          }

         // If User is not logged in
          else{
            return Login();
          }
        },
      ),
    );
  }
}
