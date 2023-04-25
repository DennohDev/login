
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/my_button.dart';
import 'package:login/components/my_textfield.dart';
import 'package:login/components/square_tile.dart';

import '../Services/auth_service.dart';

class Login extends StatefulWidget {
  final Function()? onTap;
  const Login({Key? key, this.onTap}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

 class _LoginState extends State<Login> {
  // Text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

   // Sign user in method
  void signUserIn() async {
    // Show a loading circle
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });

    // Try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      showErrorMessage(e.code);
      }
    }


    // Error Message to User
    void showErrorMessage(String message){
      showDialog(
          context: context,
          builder: (context){
       return  AlertDialog(
         backgroundColor: Colors.deepPurple,
         title: Center(
             child: Text(
                 message,
               style: const TextStyle(color: Colors.white),
             )),
        );
      });
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              //logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

              // Welcome back you've been missed
              Text(
                  'Welcome back you\'ve been missed',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),
              // Username text-field
               MyTextField(
                controller: emailController,
                hintText: 'Email',
                 obscureText: false,
              ),

              const SizedBox(height: 10),
              //password text-field
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),
              // Forgot password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Forgot Password',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              // Sign in Button
              MyButton(
                //TODO: Remember to remove the comments below
                onTap: signUserIn,
                text: 'Sign Up',
              ),

              const SizedBox(height: 50),
              // or Continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or Continue With',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Button
                  SquareTile(
                      imagePath: 'assets/images/google.png',
                    onTap: () => AuthService().signInWithGoogle(),
                  ),

                  SizedBox(width: 25),
                  // Apple button
                  SquareTile(
                    imagePath: 'assets/images/apple.png',
                    onTap: () {  },)
                ],
              ),
              const SizedBox(height: 50),

              // not a member? Register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text('Register now',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
