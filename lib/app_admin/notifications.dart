import 'dart:io';

import 'package:esalonbusiness/globals/configs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import './navigation.dart';
import './admin_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';






class Orders {
  final bool isRequested;
  final String requestedSaloonService;
  final String serviceProviderId;
  final String userId;
  final String requesteeName;
  final String phoneNumber;
  final String fcm_token;
  final String ProfilePicture;
  final double longitude;
  final double latitude;
  final bool transactionPassed;
  final String priceRequested;
  final String timeStamp;
  final String transactionalID;
  final bool isIos;

  Orders({
    this.isRequested,
    this.requestedSaloonService,
    this.serviceProviderId,
    this.userId,
    this.requesteeName,
    this.phoneNumber,
    this.fcm_token,
    this.ProfilePicture,
    this.longitude,
    this.latitude,
    this.transactionPassed,
    this.timeStamp,
    this.priceRequested,
    this.transactionalID,
    this.isIos
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
        isRequested: json['isRequested'],
        requestedSaloonService: json['requestedSaloonService'],
        serviceProviderId: json['serviceProviderId'],
        userId: json['userId'],
        requesteeName: json['requesteeName'],
        phoneNumber: json['phoneNumber'],
        fcm_token: json['fcm_token'],
        ProfilePicture: json['ProfilePicture'],
        longitude: json['longitude'],
        latitude: json['latitude'],
        transactionPassed: json['transactionPassed'],
        priceRequested: json['priceRequested'],
        timeStamp: json['timeStamp'],
        transactionalID: json['transactionalID']


    );
  }


}
class NotificationsWidget extends StatefulWidget {
  @override
  NotificationsState createState() => NotificationsState();
}

class NotificationsState extends State<NotificationsWidget> {

  String _token;
  String serviceProviderToken;
  String serviceProviderName;
  String serviceProviderImage;
  String serviceProviderPrice;
  String serviceProvided;
  String serviceProviderUid;
  String servicePrice;
  String serviceHours;
  Orders servicesFetched;
  bool shouldShow = false;
  bool renderCard = false;
  String fullName;




  stopTransaction() async {
Fluttertoast.showToast(
        msg: "Processing...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 13,
        textColor: Colors.white,
        fontSize: 16.0
    );
final Map<String, dynamic> service = {
  'uid': servicesFetched.serviceProviderId,
  'requesteeName': servicesFetched.requesteeName,
  'timeStamp': servicesFetched.timeStamp,
  'priceRequested': servicesFetched.priceRequested,
  'transactionalID': servicesFetched.transactionalID,
  'requestedService': servicesFetched.requestedSaloonService,
  'userId': servicesFetched.userId
};

 http.post('https://young-tor-95342.herokuapp.com/api/stop-transaction',body: json.encode(service),
          headers: {
            "accept": "application/json",
            "content-type": "application/json"
    }).then((result) {

                Fluttertoast.showToast(
        msg: "Service Started!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
    }).catchError((err){
 Fluttertoast.showToast(
        msg: "Oops!, something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
    });

  }



  fetchOrders() async {
    try{
SharedPreferences prefs = await SharedPreferences.getInstance();
fullName = prefs.get('fullName');
serviceProviderUid = prefs.get('uid');
print(serviceProviderUid);
    final response = await http
        .get('https://young-tor-95342.herokuapp.com/api/find-service-request/${prefs.get('uid')}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        servicesFetched =  Orders.fromJson(json.decode(response.body));
        setState(() {
          renderCard = servicesFetched.transactionPassed == false;
          shouldShow = servicesFetched.phoneNumber == null;
        });
//        shouldShow = servicesFetched.requesteeName != null;
//        isAbsent =   servicesFetched.phoneNumber == null;
      });


      return servicesFetched;
    } else {
      setState(() {
        shouldShow = true;
      });
      throw Exception('Oops something wrong');
    }
    }catch(err){
      print(err);
    }
  }


requestRating(String playerId, String contents, String headings) async {
 String url = 'https://onesignal.com/api/v1/notifications';
 bool isIos =  servicesFetched.isIos ?? false;
 if(isIos){
   Map<dynamic, dynamic> body = {
'app_id': Configs.appIdUserIosOneSignal,
'contents': {"en": contents},
'include_player_ids': [playerId],
'headings': {"en": headings},
'data': {"type": "new-stories"},
 "small_icon": "@mipmap/ic_launcher",
 "large_icon": "@mipmap/ic_launcher"
}; 
final response = await http.post(url,
body: json.encode(body),
headers: {HttpHeaders.authorizationHeader: Configs.appAuthorizationHeaderIos,
"accept": "application/json",
"content-type": "application/json"
}
);
Navigator.pushNamed(context, '/home');

 }else{
   Map<dynamic, dynamic> body = {
'app_id': Configs.appIdnewAdroidWorker,
'contents': {"en": contents},
'include_player_ids': [playerId],
'headings': {"en": headings},
'data': {"type": "new-stories"},
 "small_icon": "@mipmap/ic_launcher",
 "large_icon": "@mipmap/ic_launcher"
}; 
final response = await http.post(url,
body: json.encode(body),
headers: {HttpHeaders.authorizationHeader: Configs.authorizationHeadernewAdroidWorker,
"accept": "application/json",
"content-type": "application/json"
}
);
Navigator.pushNamed(context, '/home');
 }




}



  stopAndCharge() async {
    // no db mutation just notifications
    final response = await http
        .get('https://young-tor-95342.herokuapp.com/notify/${servicesFetched.fcm_token}/${servicesFetched.serviceProviderId}/${servicesFetched.transactionalID}/${servicesFetched.requestedSaloonService}/${servicesFetched.priceRequested}/${servicesFetched.userId}/${servicesFetched.requesteeName}');
    if (response.statusCode == 200 || response.statusCode == 201) {
// Firestore.instance.collection('users')
//     .document(servicesFetched.userId).setData({'ratingCount': 1}, merge: true).then((onValue){
//     });
 requestRating(servicesFetched.fcm_token, "Ratings", "Please Rate $fullName");
    }else{
       Fluttertoast.showToast(
        msg: "Oops!, something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
    }
  }


  launchWhatsapp(String  phone) async{
    var whatsappUrl ="whatsapp://send?phone=$phone";
    await canLaunch(whatsappUrl)? launch(whatsappUrl):Fluttertoast.showToast(
        msg: "Oops!,something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );;
  }

  void disableUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     Firestore.instance.collection('saloonServiceProvider')
    .document('${prefs.get('uid')}').setData({
      'isRequested': true
    },merge: true).then((onValue){
      print('Done!');
    }).catchError((onError){
       print('Failed!');
    });
  }

  void _settingModalBottomSheet(context){
    // disableUser();
    showModalBottomSheet(backgroundColor: Colors.transparent ,
        context: context,
        builder: (BuildContext bc){
          return  Container(
            height: 200.0,
            color: Colors.transparent,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
             Container(margin: EdgeInsets.all(8.0),
              width: 150.0,child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                     Icon(EvaIcons.phoneCallOutline),
                      Text(' Call Customer',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  onPressed: () async{
              launch("tel://${servicesFetched.phoneNumber}");
              // print(servicesFetched.fcm_token);
                  },
                  color: Colors.white,
                  padding: EdgeInsets.all(9.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),
            ),

            Container(margin: EdgeInsets.all(8.0),
              width: 158.0,child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                     Icon(EvaIcons.plusCircleOutline),
                      Text(' Start Transaction',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  onPressed: () async{
            stopTransaction();
         },
                  color: Colors.white,
                  padding: EdgeInsets.all(9.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),
            ),


            Container(margin: EdgeInsets.all(8.0),
              width: 154.0,child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                     Icon(EvaIcons.creditCardOutline),
                      Text(' Stop and Charge',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  onPressed: () {
                Fluttertoast.showToast(
        msg: "Processing...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        textColor: Colors.white,
        fontSize: 16.0
    );
                      stopAndCharge();
                  },
                  color: Colors.white,
                  padding: EdgeInsets.all(9.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),
            )
            // Container(margin: EdgeInsets.all(8.0),
            //   width: 120.0,child: RaisedButton(
            //       child: Row(
            //         children: <Widget>[
            //          Icon(Icons.cancel),
            //           Text('Cancel Call',
            //               style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
            //         ],
            //         mainAxisAlignment: MainAxisAlignment.center,
            //       ),
            //       onPressed: () {
            //    Toast.show('Processing, please wait...', context,
            //     duration: 5);
            //            Navigator.of(context).pop();
            //       },
            //       color: Colors.white,
            //       padding: EdgeInsets.all(9.0),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: new BorderRadius.circular(30.0)),
            //     ),
            // )
              ],
            ),
          );
        }
    );
  }

  void initState() {


    fetchOrders();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          title: renderCard ?  Text('') : Text('Notifications',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: renderCard  ? Column(
          children: <Widget>[
            Container(
              height: 235.0,
              color: Colors.blue,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.yellow[800],
                          backgroundImage: NetworkImage('${servicesFetched.ProfilePicture}'),
                          radius: 50.0,
                        )),
                  ),
                  Center(
                      child: Padding(
                        child: Text(
                          '${servicesFetched.requesteeName}',
                          style: TextStyle(color: Colors.white, fontSize: 16.8,fontWeight: FontWeight.w400),
                        ),padding: EdgeInsets.only(top:5.0,),
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 7.0),
                    child: Row(
                      children: <Widget>[
                        Center(
                          child: Column(children: <Widget>[
                            Text(
                              'Service Requested',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.6,
                                  fontWeight: FontWeight.w100),
                            ),
                            SizedBox(height: 2.0,),
                            Text(
                              '${servicesFetched.requestedSaloonService}',
                              style:
                              TextStyle(color: Colors.white, fontSize: 24.0,fontWeight: FontWeight.w400,fontFamily: 'food'),
                            ),
                            IconButton(onPressed: (){
  Navigator.push(context,MaterialPageRoute(builder: (context) => NavigationMaps(latitude: servicesFetched.latitude,
    longitude: servicesFetched.longitude,phoneNumber: '',serviceProviderName: servicesFetched.requesteeName,))); // servicesFetched.phoneNumber
                            },icon: Icon(EvaIcons.pin,size: 30.0,color: Colors.white,),)
                          ]),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  )
                ],
              ),
            ),//okay

            SizedBox(height: 75.0,),
            Center(
              child: RaisedButton(
                child: Text('Confirm Request',
                    style: TextStyle(color: Colors.white,fontSize: 19.0,fontWeight: FontWeight.w600,fontFamily: 'food')),
                onPressed: () {
                  _settingModalBottomSheet(context);


                },
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),color: Colors.blue[600],

              ),
            )


          ],
        ): shouldShow == true  ? Center(
          child: Text(
            'You have no requests yet',
            style: TextStyle(fontSize: 15.0),
          ),
        ): renderCard == false && shouldShow == false ?  Center(
      child: Center(child: CircularProgressIndicator() ),
    ):  Text(
            'You have no requests yet',
            style: TextStyle(fontSize: 15.0),
          ),
        backgroundColor: Colors.white);
  }

}