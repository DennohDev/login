import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login/pages/news_info.dart';

class AddNewsInfo extends StatefulWidget {
  const AddNewsInfo({super.key});

  @override
  State<AddNewsInfo> createState() => _AddNewsInfoState();
}

class _AddNewsInfoState extends State<AddNewsInfo> {
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _selectedImage;
  final _picker = ImagePicker();
  String imageUrl = '';

  void sendUserDataToDB(String imageUrl) async {

    CollectionReference addNewsCollection = FirebaseFirestore.instance.collection("News_Information");

    return addNewsCollection.doc().set({
      "title": _titleController.text,
      "content": _contentController.text,
      "image": imageUrl,
      "Timestamp": DateTime.now().toString(),
    })
    .then((value) => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsInformation()))).catchError((error) => Fluttertoast.showToast(msg: 'Something is wrong. $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('News Information', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          const Text(
            "Title",
          ),
          Container(
            width: 350,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                labelText: 'Enter your News title',
              ),
              keyboardType: TextInputType.text,
              controller: _titleController,
            ),
          ),
          Container(
            height: 250,
            width: 250,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: _selectedImage != null
                ? Image.file(_selectedImage!)
                : const Text('No Image Selected'),
            ),
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _selectedImage = File(pickedFile.path);
                  });
                }
              },
              child: const Text('Select Image'),
                ),
      
            const SizedBox(
            height: 20,
          ),
          const Text(
            "Content",
          ),
          Container(
            width: 350,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                labelText: 'Enter your News Content',
              ),
              keyboardType: TextInputType.multiline,
              controller: _contentController,
            ),
          ),
          
          ElevatedButton.icon(
              onPressed: () async {
                String title = _titleController.text;
                String content = _contentController.text;
        
                if (title.isNotEmpty && content.isNotEmpty){
                  if (_selectedImage != null) {
                    final storage = firebase_storage.FirebaseStorage.instance;
                    final imageRef = storage.ref().child('images/${DateTime.now()}.jpg');
                    await imageRef.putFile(_selectedImage!);
                    final imageUrl = await imageRef.getDownloadURL();
                    // Perform any desired operations with the imageUrl (e.g., save to database)
                   sendUserDataToDB(imageUrl);
                    Fluttertoast.showToast(msg: 'Sending Your Request');
                  } else {
                    Fluttertoast.showToast(msg: 'Please add and Image');
                    return;
                  }
                } else {
                  Fluttertoast.showToast(msg: 'Please input all fields');
                }
              },
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              label: const Text(
                'DONE',
                style: TextStyle(color: Colors.white),
              ))
            ],
          ),
        ),
      ),
    );
  }
}