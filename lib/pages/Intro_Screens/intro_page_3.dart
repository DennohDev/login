import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: Lottie.network('https://assets6.lottiefiles.com/private_files/lf30_dfxejf4d.json',
          width: 250,
          height: 250,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
