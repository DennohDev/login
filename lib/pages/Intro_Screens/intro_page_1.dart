import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class IntroPage1 extends StatelessWidget {
  const IntroPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: Center(
        child: Lottie.network(
            'https://assets5.lottiefiles.com/packages/lf20_8opq8ij6.json',
          width: 250,
          height: 250,
          fit: BoxFit.fill,
        )
      ),
    );
  }
}
