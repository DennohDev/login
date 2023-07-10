import 'package:flutter/material.dart';

import '../components/dialer.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({Key? key}) : super(key: key);

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Emergency Contacts",
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DialerButton(
                  phoneNumber: '911',
                buttonLabel: 'NATIONAL EMERGENCY',
              ),
              SizedBox(height: 20),
              DialerButton(
                phoneNumber: '999',
                buttonLabel: 'NATIONAL POLICE',
              ),
              SizedBox(height: 20),
              DialerButton(
                phoneNumber: '1199',
                buttonLabel: 'RED CROSS SERVICES',
              ),
              SizedBox(height: 20),
              DialerButton(
                phoneNumber: '+254 20 2727730',
                buttonLabel: 'NATIONAL POLICE(NANDI)',
              ),
              SizedBox(height: 20),
              DialerButton(
                phoneNumber: '+254 20 272 2639',
                buttonLabel: 'NATIONAL POLICE(ELDORET)'
              ),
              SizedBox(height: 20),
              DialerButton(
                phoneNumber: '+254 20 4182000',
                buttonLabel: 'NATIONAL POLICE (NAIROBI)',
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );

  }
}

