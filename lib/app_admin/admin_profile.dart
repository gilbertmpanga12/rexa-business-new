import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import './new_edit.dart';
import './admin_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileWidget  extends StatefulWidget {
  @override
  ProfileWidgetState createState() => ProfileWidgetState();
}

class ProfileWidgetState extends State<ProfileWidget> {
String profilePicture;
String displayName;
String phoneNumber;
String businessName;
String _firebaseUID;


  @override
  initState(){

    localStorage();
    super.initState();

  }

  localStorage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('profilePicture'));
     print(prefs.getString('fullName'));
      print(prefs.getString('phoneNumber'));
    setState(() {
      profilePicture = prefs.getString('profilePicture');
      displayName = prefs.getString('fullName');
      phoneNumber = prefs.getString('phoneNumber');
      businessName = prefs.getString('businessName');
      _firebaseUID = prefs.getString('uid');
    });

  }




  uploadPhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  
    ImagePicker.pickImage(source: ImageSource.gallery).then((image){
      if(image == null){
    return;
  }
      final url = randomAlpha(10);
      final StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('${url}');
      final StorageUploadTask task =
      firebaseStorageRef.putFile(image);

      showDialog(context: context,builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
          content: Row(children: <Widget>[
          Container(child: CircularProgressIndicator(),margin: EdgeInsets.only(right: 10.0),),
          Container(child: Text('Processing...',style: TextStyle(fontSize: 17.0),),)
        ],),);
      });

      task.onComplete.then((image){
        firebaseStorageRef.getDownloadURL().then((result) {

          final Map<String, dynamic> service = {
            'profilePicture': result.toString(),
            'uid': prefs.getString('uid')
          };
          prefs.setString('profilePicture', service['profilePicture']);
          setState(() {
            profilePicture = service['profilePicture'];
          });
          http.post('https://young-tor-95342.herokuapp.com/api/provider-update-profile-picture',
              body: json.encode(service),
              headers: {
                "accept": "application/json",
                "content-type": "application/json"
              }).then((response){
            if(response.statusCode == 200 || response.statusCode == 201){
  Navigator.of(context, rootNavigator: true).pop('dialog');
              showDialog(context: context,builder: (BuildContext context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
                  title: Text('Success'),
                  content: Text('Your profile picture has been updated'),actions: <Widget>[
                  FlatButton(child: Text('OK'),onPressed: (){
                    Navigator.of(context, rootNavigator: true).pop('dialog');

                  },)
                ],);
              });
            }else{
              print(response.body);
              Navigator.of(context, rootNavigator: true).pop('dialog');
              showDialog(context: context,builder: (BuildContext context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
                  title: Text('Oops something went wrong'),
                  content: Text('Please try again or contact support team'),actions: <Widget>[
                  FlatButton(child: Text('OK'),onPressed: (){
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },)
                ],);
              });
              throw Exception('Oops something wrong');
            }
          });

        });
      });

    });
  }


  Widget build(BuildContext context){
    return WillPopScope(child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.black,
            fontSize: 17,
            fontFamily: 'Comfortaa',fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 0,
         
        ),
        body: StreamBuilder(
                      stream: Firestore.instance.collection('saloonServiceProvider').document('${_firebaseUID}').snapshots(),
                      builder: (context, snapshot) {
                        try{
print('$_firebaseUID');
                        print('${snapshot.data}');
                        if(!snapshot.hasData){
                          return Center(child: CircularProgressIndicator());
                        }
                        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20.0, left: 0, right: 20.0),
            child: Column(
              children: <Widget>[
                Stack(children: <Widget>[
                  Container(
                  child: InkWell(
                    child: CircleAvatar(
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.yellow[700],
                      backgroundImage: new NetworkImage(
                          '${snapshot.data['profilePicture']}'),
                      radius: 66.0,
                    ),onTap: (){
                    uploadPhoto();
                  },
                  ),
                  margin: EdgeInsets.only(left: 18.0, bottom: 25.0),
                ),
                 Positioned(bottom: 20.6,child: SizedBox(
                   height: 30,width: 30,
                   child: FloatingActionButton(backgroundColor: Colors.yellow[900],
                   mini: true,
                   onPressed: () => uploadPhoto(),
                   child: Icon(Icons.add,color: Colors.white,),),),right: 13,)
                ],),
                ListTile(
                  leading: Icon(
                      Icons.person,
                      color: Colors.yellow[800]
                  ),
                  title: Text('Name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, )),
                  subtitle: Text('${snapshot.data['fullName']}',style: TextStyle(fontSize: 15,
                  fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),

                ),
                Container(child: Divider(indent: 57.8,),padding: EdgeInsets.only(left:12.0),),

                ListTile(
                  leading: Icon(Icons.info, color: Colors.yellow[800]),
                  title: Text(
                    'Telephone',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Text('${snapshot.data['phoneNumber']}',style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontSize: 15.0,fontWeight: FontWeight.bold)),
                ),
                Container(child: Divider(indent: 57.8,),padding: EdgeInsets.only(left:12.0),),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.yellow[800]),
                  title: Text('Business name',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
                  subtitle: Text('${snapshot.data['businessName']}',style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontSize: 15.0,fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
                        }catch(err){
                          return Center(child: Text('Loading...'));
                        }
                      }
                  )
    ),onWillPop: (){
      Navigator.pop(context, MaterialPageRoute(builder: (context) => AdminHome()));
      return Future.value(false);
    },);
  }
}
