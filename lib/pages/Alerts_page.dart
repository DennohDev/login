// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'home_page.dart';

class Alert extends StatefulWidget {
  const Alert({super.key});

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final CollectionReference _Alerts =
      FirebaseFirestore.instance.collection('Alerts');
  var currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController _alertController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? mtoken = " ";
  List<String> tokens = [];
  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
    initInfo();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Handle authorisation status
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      Fluttertoast.showToast(msg: 'User declined Permission');
      print('User declined or has not accepted permission');
    }
  }

  // Get device token
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print('My token is $mtoken');
      });
      saveToken(token!);
    });
  }

  // Save device token
  void saveToken(String token) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(currentUser!.email)
        .set({'token': token});
  }

  // initializations for local plugins
  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationsSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("...........onMessage.............");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('myid', 'myid',
              importance: Importance.high,
              styleInformation: bigTextStyleInformation,
              priority: Priority.high,
              playSound: true);
      NotificationDetails plaformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, plaformChannelSpecifics,
          payload: message.data['title']);
    });
  }

  void sendPushMessage(List<String> tokens, String title, String body) async {
    try {
      for (String token in tokens) {
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key= Your api key'
            },
            body: jsonEncode(<String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'body': body,
                'title': title,
              },
              "notification": <String, dynamic>{
                "title": title,
                "body": body,
                "android_channel_id": "myid"
              },
              "to": token,
            }));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error Push notification");
      }
    }
  }

  Future<void> sendSMS(alert, content) async {
    final url = Uri.parse('https://api.mobitechtechnologies.com/sms/sendsms');

    final headers = {
      'h_api_key':
          '// your api key',
      'Content-Type': 'application/json',
    };
    // Fetch phoneNumbers from Database
    List<String> phoneNumbers = await fetchPhoneNumbers();

    for (var phoneNumber in phoneNumbers) {
      final body = jsonEncode({
        "mobile": phoneNumber,
        "response_type": "json",
        "sender_name": "23107",
        "message": "$alert\n $content",
        "service_id": 0
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('SMS sent successfully');
      } else {
        print('Failed to send SMS. Error code: ${response.statusCode}');
      }
    }
  }

  Future<List<String>> fetchPhoneNumbers() async {
    final url =
        Uri.parse('https://e0ec-41-89-162-2.ngrok-free.app/api/phone-numbers');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<String> phoneNumbers = response.body.split('\n');
        return phoneNumbers;
      } else {
        print(
            'Failed to fetch phone numbers. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch phone numbers. Exception: $e');
    }

    return []; // Return an empty list in case of failure
  }

  Future<void> _sendAlert([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _alertController.text = documentSnapshot['title'];
      _contentController.text = documentSnapshot['body'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _alertController,
                  decoration: const InputDecoration(labelText: 'Alert Title'),
                ),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Alert Message',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final String alert = _alertController.text;
                        final String content = _contentController.text;
                        if (alert.isNotEmpty && content.isNotEmpty) {
                          await _Alerts.doc().set({
                            "title": alert,
                            "body": content,
                            "Timestamp": DateTime.now()
                          });
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("UserTokens")
                              .get();

                          for (QueryDocumentSnapshot documentSnapshot
                              in snap.docs) {
                            String token =
                                documentSnapshot.get('token') as String;
                            tokens.add(token);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Please fill in all feilds');
                        }
                        sendPushMessage(tokens, alert, content);
                        sendSMS(alert, content);
                        _alertController.text = '';
                        _contentController.text = '';
                        Navigator.pop(context);
                      },
                      child: const Text('Send'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'))
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<void> _updateAlert([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _alertController.text = documentSnapshot['title'];
      _contentController.text = documentSnapshot['body'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _alertController,
                  decoration: const InputDecoration(labelText: 'Alert Title'),
                ),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Alert Message',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final String alert = _alertController.text;
                        final String content = _contentController.text;
                        if (alert.isNotEmpty && content.isNotEmpty) {
                          await _Alerts.doc(documentSnapshot!.id).set({
                            "title": alert,
                            "body": content,
                            "Timestamp": DateTime.now()
                          });
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("UserTokens")
                              .get();

                          for (QueryDocumentSnapshot documentSnapshot
                              in snap.docs) {
                            String token =
                                documentSnapshot.get('token') as String;
                            tokens.add(token);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Please fill in all feilds');
                        }
                        sendPushMessage(tokens, alert, content);
                        sendSMS(alert, content);
                        _alertController.text = '';
                        _contentController.text = '';
                        Navigator.pop(context);
                      },
                      child: const Text('Update'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _alertController.text = '';
                          _contentController.text = '';
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'))
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _Alerts.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted an Alert')));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Send Alert'),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: _Alerts.orderBy("Timestamp", descending: false).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      isThreeLine: true,
                      leading: const Icon(Icons.notifications_active_rounded,
                          color: Colors.red),
                      title: Text(documentSnapshot['title']),
                      subtitle: Text(
                        documentSnapshot['body'],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () => _updateAlert(documentSnapshot),
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () => _delete(documentSnapshot.id),
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _sendAlert();
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.notification_add),
        ),
      ),
    );
  }
}
