import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadNin extends StatefulWidget {
  @override
  _UploadNinState createState() => new _UploadNinState();
}

class _UploadNinState extends State<UploadNin> {

  uploadPicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ImagePicker.pickImage(source: ImageSource.gallery).then((image){
      final url = randomAlpha(10);
      final StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('$url');
      final StorageUploadTask task =
      firebaseStorageRef.putFile(image);
       task.onComplete.then((image){
         firebaseStorageRef.getDownloadURL().then((result) {
           final String nationalId = result.toString();
           Firestore.instance.collection(prefs.getString('uid')).document().setData({
             'nationalId': '$nationalId'
           }, merge: true).then((onValue){
             print('HoXE');
           }).catchError((onError){
             print('EXE');
           });
         });

       });
    }).catchError((onError) {
      print('EXE ${onError.message}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: Center(child: Text(''),));
  }
}