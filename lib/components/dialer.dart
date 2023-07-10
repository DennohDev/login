import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class DialerButton extends StatelessWidget {
  final String phoneNumber;
  final String buttonLabel;

  const DialerButton(
      {super.key, required this.phoneNumber, required this.buttonLabel});

  void _launchDialer() async {
    if(await Permission.phone.request().isGranted){
      try{
        bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (!res!) {
      throw 'Could not launch the dialer';
    }
      } catch(error) {
        Fluttertoast.showToast(msg: 'Failed To make phone call: $error');
      }
    } else {
      Fluttertoast.showToast(msg: 'Phone call permission is denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchDialer,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 60)),
        textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(fontSize: 16, color: Colors.black)),
      ),
      child: Text(buttonLabel),
    );
  }
}
