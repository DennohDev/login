import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Center(
        child: Lottie.network('https://assets6.lottiefiles.com/packages/lf20_jol43osd.json',
          width: 300,
          height: 250,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
