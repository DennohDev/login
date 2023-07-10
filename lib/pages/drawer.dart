import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/pages/login_or_register_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
User? _currentUser;
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }
  void _getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    setState(() {
      _currentUser = user;
    });
  }
   // Sign the user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_currentUser!.displayName ?? ''),
            accountEmail: Text(_currentUser!.email ?? ''),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(),
            ),
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),

          InkWell(
            child: const ListTile(
              title: Text('Exit'),
              leading: Icon(Icons.exit_to_app),
            ),
            onTap: () {
              Navigator.push(
            context, MaterialPageRoute(builder: (_) => const LoginOrRegisterPage()));
            },
          ),
        ],
      ),
    );
  }
}
