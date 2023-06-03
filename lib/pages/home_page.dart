import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
   HomePage({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  // Sign the user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))],
      ),
      body:  Center(child: Text('LOGGED IN AS: ${user.email!}',
      style: const TextStyle(fontSize: 20)
      )
      ),
    );
  }
}
