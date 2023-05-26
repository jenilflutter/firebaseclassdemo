import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseclassdemo/Mygg.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StoreageFirebase extends StatefulWidget {
  const StoreageFirebase({Key? key}) : super(key: key);

  @override
  State<StoreageFirebase> createState() => _StoreageFirebaseState();
}

class _StoreageFirebaseState extends State<StoreageFirebase> {
  String imageee = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
// Pick an image.
                    final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      imageee = image!.path;
                    });
                  },
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: FileImage(File(imageee)),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    final storageRef = FirebaseStorage.instance.ref();
                    String imagename =
                        "Image${DateTime
                        .now()
                        .day}${DateTime
                        .now()
                        .second}.jpg";
                    final mountainImagesRef =
                    storageRef.child("Roshanibenimages/$imagename");
                    await mountainImagesRef.putFile(File(imageee));
                    mountainImagesRef.getDownloadURL().then((value) async {
                      print("=====$value");
                      // DatabaseReference ref = FirebaseDatabase.instance.ref();
                      DatabaseReference ref =
                      FirebaseDatabase.instance.ref("RoshniRealtime").push();
                      String? id = ref.key;
                      await ref.set({
                        "id": id,
                        "name": "Haresh",
                        "imageurl": value
                      }).then((value) {

                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return  ViewData();
                        },));

                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(
                            "DATA ADDED")));
                      });
                    });
                  },
                  child: Text("Add Image In firebase"))
            ],
          )),
    );
  }
}
