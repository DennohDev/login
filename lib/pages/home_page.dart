import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/components/icon_card.dart';
import 'package:login/pages/Alerts_page.dart';
import 'package:login/pages/drawer.dart';
import 'package:login/pages/emergency_page.dart';
import 'package:login/pages/guidance_page.dart';
import 'package:login/pages/news_info.dart';
import 'package:login/pages/report_threats_page.dart';
import 'package:login/pages/travel_page.dart';

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
    return WillPopScope(
       onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text('Secure Kenya Admin', style: TextStyle(
            fontWeight:FontWeight.bold)),
        ),
        drawer: const MyDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconCard(
                      text: 'News Information',
                      imagePath: 'assets/images/world.png',
                      color: Colors.blue.shade100,
                     onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewsInformation())),
                    ),
                    IconCard(
                      imagePath: 'assets/images/info.png',
                      text: 'Travel Advisories',
                      color: Colors.brown.shade100,
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TravelPage()))
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconCard(
                      imagePath: 'assets/images/secure-shield.png',
                      text: 'Report Threats',
                      color: Colors.green.shade100,
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReportThreatsPage()))
                    ),
                    IconCard(
                      imagePath: 'assets/images/information.png',
                      text: 'Guidance',
                      color: Colors.lightBlue.shade100,
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GuidancePage()))
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconCard(
                      imagePath: 'assets/images/megaphone.png',
                      text: 'Terrorist Alerts',
                      color: Colors.redAccent.shade100,
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Alert())),
                    ),
                    IconCard(
                      imagePath: 'assets/images/ambulance.png',
                      text: 'Emergency',
                      color: Colors.deepPurple.shade100,
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EmergencyPage())),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
