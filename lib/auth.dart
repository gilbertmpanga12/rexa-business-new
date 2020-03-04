import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esalonbusiness/terms_and_conditions.dart';
import 'package:flutter/material.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:random_string/random_string.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './app_admin/admin_home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';


class UserNew {
  final bool isNew;
  UserNew({this.isNew});
  factory UserNew.fromJson(Map<String, dynamic> json){
    return UserNew(
        isNew: json['isNew']
    );
  }

}

class SignIn extends StatefulWidget{
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignIn> {
  bool loading;
  String authId = randomAlpha(10);
  String _textCtaUser = 'CREATE ACCOUNT';
  bool showSpinner = false;
  double paddingTitle;
  var location = new Location();
  bool isNew;
  String _playerId;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Observable<FirebaseUser> user;



Future<dynamic> errorDialog(String  errorMessage) async{
     try {
        await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                         shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
                  title: Text('Oops something went wrong'),
                  content: Container(child: Text('$errorMessage'),width: 200.0,),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                       setState(() {
                         showSpinner = false;
                       });
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      },
                    )
                  ],
                );
              });
  setState(() {
showSpinner = false;
    });
     }catch(e){
setState(() {
 showSpinner = false;
    });
     }
  }



    googleSignIn() async {
    if(mounted){
   setState(() {
  showSpinner = true;
  });
  }
                    
    try{
GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final AuthCredential userCreadentialize = GoogleAuthProvider.getCredential(
     accessToken: googleAuth.accessToken,
     idToken: googleAuth.idToken,
   );
   
    _auth.signInWithCredential(userCreadentialize).then((user){
    prefs.setString('token', '${googleAuth.idToken}');
    prefs.setString('email', '${user.user.email}');
    prefs.setString('uid', '${user.user.uid}');
    prefs.setString('profilePicture', '${user.user.photoUrl}');
    prefs.setString('fullName', '${user.user.displayName}');
    Firestore.instance.collection('saloonServiceProvider').document(user.user.uid).get().then((newuser){
      if(newuser.exists){
        prefs.setBool('isNewUser', false);
        prefs.setBool('isSignedIn', true);

        prefs.setString('countryCode', newuser.data['countryCode']);
        prefs.setString('currencyCode', newuser.data['countryCode']);
        prefs.setString('fullName', newuser.data['fullName']); // profilePicture
        prefs.setString('profilePicture', newuser.data['ProfilePicture']);
        prefs.setString('location', newuser.data['location']);//location
        prefs.setString('phoneNumber', newuser.data['phoneNumber']); //customNumber
        prefs.setDouble('long', newuser.data['longitude']);
        prefs.setDouble('lat', newuser.data['latitude']);

        prefs.setString('serviceCategoryName', newuser.data['serviceCategoryName']);
        prefs.setString('subCategory', newuser.data['subCategory']);
        prefs.setString('countryCode', newuser.data['countryCode']);// countryCode
        prefs.setString('currencyCode', newuser.data['currencyCode']);
        prefs.setString('businessName', newuser.data['businessName']);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome()));
      }else{
        // prefs.setString('fcm_token', _playerId);
        prefs.setBool('isNewUser', true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TermsWid()));
      }
    });

    }).catchError((onError){
      if(mounted){
       setState(() {
      showSpinner = false;
      });
   }
   // dialog to be used here
   errorDialog(onError.message);
    });
    }catch(e){
errorDialog('Oops something went wrong. Try again');
    }
 
  }




  _getLocation() async {
    var currentLocation;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //  var status = await OneSignal.shared.getPermissionSubscriptionState();
    //   _playerId = status.subscriptionStatus.userId;  
      // prefs.setString('fcm_token', _playerId);
    try {
      currentLocation  = await location.getLocation();
      prefs.setDouble('lat', currentLocation.latitude);
      prefs.setDouble('long', currentLocation.longitude);
      isNew = prefs.getBool('isNew');
    } catch (e) {
      print('Failed to get location');
    }
  }



  void initState(){
    _getLocation();
    super.initState();
  }

  Widget defaultButtonText(){
    return showSpinner ? SizedBox(child: 
    CircularProgressIndicator(backgroundColor: Colors.white,),
    height: 18.5,width: 18.5,) : Row(
                    children: <Widget>[
                      // Image.asset(
                      //   'assets/google.png',
                      // ),
                      // Text('  '),
                      Text('$_textCtaUser',
                          style: TextStyle(color: Colors.white))
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  );
  }

  

  Widget build(BuildContext context) {
    // var height  = MediaQuery.of(context).size.height;
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 5.0,
          ),
          Center(
              child: Container(
                padding: EdgeInsets.only(top: 30.0),
              )),
          Center(
              child: Container(
                child: Text('Rexa',
                    style: TextStyle(
                        fontSize: 35.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,fontFamily: 'Meriada')),
                padding: EdgeInsets.only(top: 18.0),
              )),
          Center(
              child: Container(
                  child: Padding(
                      padding: EdgeInsets.only(left:45.0,right:45.0),
                      child: Text('Get started with your service provider account',
                        style: TextStyle(
                          fontSize: 19.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,fontFamily: '',height: 1.3),textAlign: TextAlign.center,))
              )),
SizedBox(height: 260.0,),

          Column(
            children: <Widget>[

              Container(
                child: RaisedButton(
                  child: defaultButtonText(),
                  onPressed: () {
                    googleSignIn();
                  },
                  color: Colors.blue[600],
                  padding: EdgeInsets.all(16.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),
                width: 217.0,
              ),

              Container(child: Column(
                // crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: 20.0,width: 64.0,),
                  Padding(
                    child: Text('©2019 elyfez Technologies  All rights reserved. "Katumba"',
                      style: TextStyle(color:Colors.black87,
                      fontWeight: FontWeight.w600,fontSize: 13
                      ),textAlign: TextAlign.center,
                      ),
                   //  SizedBox(height: 8.0,),
                    padding: EdgeInsets.only(left: 36.5,right: 39.0,bottom: 3.0,top:5.0),
                  ),
                ],
              ))

            ],
          ),
        ],
      ),
    ),);
  }

}
