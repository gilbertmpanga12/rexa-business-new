
// import 'package:apple_sign_in/apple_sign_in.dart';
// import 'package:apple_sign_in/apple_sign_in_button.dart';
import 'package:apple_sign_in/scope.dart';
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

import 'app_services/auth_service.dart';



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



    googleSignIn() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
     
    if(mounted){
   setState(() {
  showSpinner = true;
  });
  }
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
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
  
   errorDialog(onError.message);
    });
 
  }


//  Future<void> _signInWithApple(BuildContext context) async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
   
//   try {
    
//     final user = await authService.signInWithApple(
//         scopes: [Scope.email, Scope.fullName]);
//     prefs.setString('token', '${user.getIdToken()}');
//     prefs.setString('email', '${user.email}');
//     prefs.setString('uid', '${user.uid}');
//     prefs.setString('profilePicture', '${user.photoUrl}');
//     prefs.setString('fullName', '${user.displayName}');
//     Firestore.instance.collection('saloonServiceProvider').document(user.uid).get().then((newuser){
//       if(newuser.exists){
//         prefs.setBool('isNewUser', false);
//         prefs.setBool('isSignedIn', true);
//         prefs.setString('countryCode', newuser.data['countryCode']);
//         prefs.setString('currencyCode', newuser.data['countryCode']);
//         prefs.setString('fullName', newuser.data['fullName']); // profilePicture
//         prefs.setString('profilePicture', newuser.data['ProfilePicture']);
//         prefs.setString('location', newuser.data['location']);//location
//         prefs.setString('phoneNumber', newuser.data['phoneNumber']); //customNumber
//         prefs.setDouble('long', newuser.data['longitude']);
//         prefs.setDouble('lat', newuser.data['latitude']);

//         prefs.setString('serviceCategoryName', newuser.data['serviceCategoryName']);
//         prefs.setString('subCategory', newuser.data['subCategory']);
//         prefs.setString('countryCode', newuser.data['countryCode']);// countryCode
//         prefs.setString('currencyCode', newuser.data['currencyCode']);
//         prefs.setString('businessName', newuser.data['businessName']);
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome()));
//       }else {
//         // prefs.setString('fcm_token', _playerId);
//         prefs.setBool('isNewUser', true);
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TermsWid()));
//       }
      
//       });
  
//   } catch (e) {
//     errorDialog(e.toString());
//   }
// }



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
  //   AppleSignIn.onCredentialRevoked.listen((_) {
  //   print("Credentials revoked -------------------------------------------------");
  // });
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


Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
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
                        fontFamily: 'Monoton')),
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
InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
   googleSignIn();
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width -51,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffffffff).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.blueAccent),
        child: defaultButtonText(),
      ),
    ),
              
// SizedBox(height: 3,),
// Theme.of(context).platform == TargetPlatform.iOS ?_divider(): SizedBox.shrink(),
// SizedBox(height: 3,),
//     Theme.of(context).platform == TargetPlatform.iOS ? Container(child: AppleSignInButton( 
//   style: ButtonStyle.black,
//   type: ButtonType.signIn,
//   onPressed: () => _signInWithApple(context),
// ),width: MediaQuery.of(context).size.width -51,): SizedBox.shrink(),

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
