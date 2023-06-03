import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage4 extends StatelessWidget {
  const IntroPage4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink,
      child: Center(
        child: Lottie.network('https://assets7.lottiefiles.com/packages/lf20_mjlh3hcy.json',
          width: 250,
          height: 250,
          fit: BoxFit.fill,
        )
      ),
    );
  }
}
