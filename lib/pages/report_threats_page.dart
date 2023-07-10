import 'package:flutter/material.dart';
import 'package:login/pages/chat_page.dart';

class ReportThreatsPage extends StatefulWidget {
  const ReportThreatsPage({super.key});

  @override
  State<ReportThreatsPage> createState() => _ReportThreatsPageState();
}

class _ReportThreatsPageState extends State<ReportThreatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Report Threats',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage()));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Colors.blueAccent,
                ),
                title: Text('Report to the Authorities'),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              )),
        ],
      ),
    );
  }
}
