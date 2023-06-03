
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/Services/auth_service.dart';
import 'package:login/components/my_button.dart';
import 'package:login/components/my_textfield.dart';
import 'package:login/components/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({Key? key, this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Sign user up method
  void signUserUp() async {
    // Try Creating the user
    try {
      // Check if both of the passwords are same
      if (passwordConfirmed()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

      } else {
        // show error message, passwords don't match
        showErrorMessage('Passwords don\'t match');
      }

    } on FirebaseAuthException catch (e) {
      // WRONG EMAIL
      showErrorMessage(e.code);
    }
  }
  bool passwordConfirmed() {
    if (passwordController.text.trim() ==
        confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
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
              size: 50,
            ),

            const SizedBox(height: 50),

            // Let's create an account
            Text(
              'Let\'s Create an account for you',
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
            //confirm password text-field
            MyTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),



            const SizedBox(height: 25),
            // Sign in Button
            MyButton(
              //TODO: Remember to remove the comments below
              onTap: signUserUp,
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
                SquareTile(imagePath: 'assets/images/google.png',
                  onTap: () => AuthService().signInWithGoogle(),
                  ),
              ],
            ),
            const SizedBox(height: 50),

            // not a member? Register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an Account?',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text('Login now',
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
