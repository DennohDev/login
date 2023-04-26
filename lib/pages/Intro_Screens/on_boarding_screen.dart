import 'package:flutter/material.dart';
import 'package:login/pages/auth_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'intro_page_1.dart';
import 'intro_page_2.dart';
import 'intro_page_3.dart';
import 'intro_page_4.dart';
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  // Controller to keep track of the pages
  final PageController _controller = PageController();

  // Boolean to keep track if we are in the last page or not
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 3);
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
              IntroPage4(),
            ],
          ),
          
          // dot indicators
          Container(
            alignment: const Alignment(0,0.85),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Skip button
                  GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(3);
                    },
                      child: const Text('Skip'),
                  ),
                  
                  //dot indicator
                  SmoothPageIndicator(
                      controller: _controller,
                      count: 4,
                  ),

                  // Next or done
                  onLastPage ?
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const AuthPage();
                          }
                        )
                      );
                    },
                      child: const Text('Done'),
                  )
                  : GestureDetector(
                    onTap: () {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                      },
                    child: const Text('Next'),
                  ),
                  
                ],
              ),
          ),
        ],
      ),
    );
  }
}
