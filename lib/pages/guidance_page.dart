import 'package:flutter/material.dart';
import 'package:login/pages/add_guidance_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/pages/home_page.dart';

class GuidancePage extends StatefulWidget {
  const GuidancePage({super.key});

  @override
  State<GuidancePage> createState() => _GuidancePageState();
}

class _GuidancePageState extends State<GuidancePage> {
  final CollectionReference guidanceInfoCollection =
      FirebaseFirestore.instance.collection('Guidance_Information');
  @override
  Widget build(BuildContext context) {
    double dh = MediaQuery.of(context).size.height;
    double dw = MediaQuery.of(context).size.width;
    return WillPopScope(
       onWillPop: () async{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Guidance Page',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddGuidancePage()));
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: dw,
            height: dh,
            child: StreamBuilder(
              stream: guidanceInfoCollection
                  .orderBy('Timestamp', descending: false)
                  .snapshots(),
              builder:
                  (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      if (index == streamSnapshot.data!.docs.length -1){
                        return Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              documentSnapshot['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                                width: 350,
                                height: 300,
                                child:
                                    Image.network(documentSnapshot['image'])),
                            const SizedBox(height: 10),
                            Text(documentSnapshot['content']),
                            const SizedBox(height: 10),
                            Text(
                              documentSnapshot['Timestamp'].toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                      } else {
                        return Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              documentSnapshot['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                                width: 350,
                                height: 300,
                                child:
                                    Image.network(documentSnapshot['image'])),
                            const SizedBox(height: 10),
                            Text(documentSnapshot['content']),
                            const SizedBox(height: 10),
                            Text(
                              documentSnapshot['Timestamp'].toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                      }
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}
