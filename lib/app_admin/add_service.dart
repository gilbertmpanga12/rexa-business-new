import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import './admin_success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import './myoffice.dart';
import '../mainOps/create_service.dart';
import 'package:http/http.dart' as http;
import 'package:rave_flutter/rave_flutter.dart';

class Premium {
  final bool account_upgrade;
  Premium({this.account_upgrade});
  factory Premium.fromJson(Map<String, dynamic> json) {
    return Premium(account_upgrade: json['account_upgrade']);
  }
}


class _Categories{
  final String categoryName;
  final String categoryId;

  _Categories({this.categoryName, this.categoryId});
  factory _Categories.fromJson(Map<String, dynamic> json) {
    return _Categories(
        categoryName: json['categoryName'], categoryId: json['categoryId']);
  }
}

class Total {
  final String total;
  final String percentile;
  Total({this.total, this.percentile});
  factory Total.fromJson(Map<String, dynamic> json) {
    return Total(
        total: '${json['total']}',
        percentile: '${json['percentile']}'
    );
  }

}

class _Services {
  final String serviceName;
  final String categoryName;

  _Services({this.categoryName, this.serviceName});
  factory _Services.fromJson(Map<String, dynamic> json) {
    return _Services(
        serviceName: json['serviceName'], categoryName: json['categoryName']);
  }
}

class CreateServiceWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateServiceWidgetState();
  }
}

class _CreateServiceWidgetState extends State<CreateServiceWidget> {
  String  _category;
  String _serviceProvided;
  String _timeTaken;
  String _price;
  File _image;
  bool isNetworkError = false;
  String shippingAdress;

  String _token;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String _description;
  bool isPremium;
  String isUid;
  String _website;
  bool hasExceeded = false;

  List<_Categories> categoriesFetched = List();
  List<_Services> servicesFetched = List();
    var scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  fetchTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
isUid = prefs.getString('uid');
    });
  }


_launchURL(String activityType) async {
    var initializer = RavePayInitializer(
        amount: 500, publicKey: 'FLWPUBK-fd13744184c7c4ec3fb622ababef95a5-X', 
        encryptionKey: 'FLWSECK-fb7f8d35b0b235c849198c0ab613e230-X')
      ..country = "KE"
      ..currency = "KES"
      ..email = "gilbertmpanga.gm@gmail.com"
      ..fName = "Ciroma"
      ..lName = "Adekunle"
      ..narration = 'narration' ?? ''
      ..txRef = 'txRef'
      //..subAccounts = subAccounts
      ..acceptMpesaPayments = true
      ..acceptAccountPayments = true
      ..acceptCardPayments = true
      ..acceptAchPayments = true
      ..acceptGHMobileMoneyPayments = true
      ..acceptUgMobileMoneyPayments = true
      ..staging = true
      ..isPreAuth = true
      ..displayFee = true;

    // Initialize and get the transaction result
    RaveResult response = await RavePayManager()
        .prompt(context: context, initializer: initializer).catchError((onError){
          print(onError);
        });
       print(response?.message);
}

  Widget _buildServiceProvidedTextField() {
    return TextFormField(
     
        textCapitalization: TextCapitalization.words,
        maxLines: 2,
        decoration: InputDecoration(labelText: 'Service offered'),
        onSaved: (String value) {
          _serviceProvided = value;
        });
}

Widget _buildWebsite() {
    return Row(children: <Widget>[
      Icon(EvaIcons.creditCard,color: Colors.yellow[800],),
      SizedBox(width: 3.0,),
      Container(child: TextFormField(
        textCapitalization: TextCapitalization.words,
        maxLines: 2,
        decoration: InputDecoration(labelText: '(Premium) Add a website or link'),
        onSaved: (String value) {
          _website = value;
        }),width: 257.0,)
    ]);
}

Widget _buildLink() {
   return Row(children: <Widget>[
      Icon(EvaIcons.carOutline,color: Colors.blue[800],),
      SizedBox(width: 3.0,),
      Container(child: TextFormField(
        textCapitalization: TextCapitalization.words,
        maxLines: 2,
        decoration: InputDecoration(labelText: 'Add Shipping Address or link'),
        onSaved: (String value) {
          shippingAdress = value;
        }),width: 257.0,)
    ]);
}

void uploadVideo(bool isVideo) async {
SharedPreferences prefs = await SharedPreferences.getInstance();
ImagePicker.pickVideo(source: ImageSource.gallery).then((image){
        final url = randomAlpha(10);
        final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('${url}');
        final StorageUploadTask task =
        firebaseStorageRef.putFile(image);

      showDialog(
        
        context: context,builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
          content: Row(children: <Widget>[
          Container(child: CircularProgressIndicator(),margin: EdgeInsets.only(right: 10.0),),
          Container(child: Text('Processing...',style: TextStyle(fontSize: 17.0),),)
        ],),);
      });

      task.onComplete.then((taskDone){
final docID = randomAlpha(12);
firebaseStorageRef.getDownloadURL().then((result) {
 serviceCreator.addService(_price + prefs.getString('currencyCode'), 
prefs.getString('serviceCategoryName'), _serviceProvided[0].toUpperCase() + _serviceProvided.substring(1,), 
result.toString(), prefs.getString('uid'), 
'N/A', false, isVideo, _description, false, _website, shippingAdress, 
prefs.getString('subCategory'), _price, _timeTaken,prefs.getString('countryCode'),
'servicesvideofeed', prefs.getString('location'),prefs.getString('phoneNumber'),
prefs.getDouble('long'),prefs.getDouble('lat'),
prefs.getString('profilePicture'),
prefs.getString('fullName'),
docID
).then((val){
  final Map<String, dynamic> transcoderPayload = {
          'uid': docID,
          'imageUrl': result.toString(),
          'isBusiness': true
   };
  if(val == 1){
    // Fluttertoast.cancel();
    
     Navigator.of(context, rootNavigator: true).pop('dialog');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminSuccessWidget()));
//     http.post('http://35.246.43.91/crucken-transcord',
//             body: json.encode(transcoderPayload),
//             headers: {
//               "accept": "application/json",
//               "content-type": "application/json"
//    }).then((onValue){
// // sendToUsersSegment();
//             }).catchError((onError){
// print('failed to transcord image');
//             });
  }else if(val == 443){
//     http.post('http://35.246.43.91/crucken-transcord',
//             body: json.encode(transcoderPayload),
//             headers: {
//               "accept": "application/json",
//               "content-type": "application/json"
//    }).then((onValue){
// // sendToUsersSegment();
//             }).catchError((onError){
// print('failed to transcord image');
//             });
   Navigator.of(context, rootNavigator: true).pop('dialog');
          showDialog(context: context,builder: (BuildContext context){
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
                    title: Text('Account deactived'),
                    content: Text('Upgrade to a premium account with just \$27.26 only. Contact support to get started'),actions: <Widget>[
                    FlatButton(child: Text('OK'),onPressed: (){
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },)
                  ],);
                });

  }else{
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

}).catchError((onError){
  // Navigator.of(context, rootNavigator: true).pop('dialog');
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
});

});
      });

       });
}



void uploadPhoto(bool isVideo) async {
  final docID = randomAlpha(12);
SharedPreferences prefs = await SharedPreferences.getInstance();
ImagePicker.pickImage(source: ImageSource.gallery).then((image){
        final url = randomAlpha(10);
        final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('${url}');
        final StorageUploadTask task =
        firebaseStorageRef.putFile(image);

         showDialog(
        
        context: context,builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
          content: Row(children: <Widget>[
          Container(child: CircularProgressIndicator(),margin: EdgeInsets.only(right: 10.0),),
          Container(child: Text('Processing...',style: TextStyle(fontSize: 17.0),),)
        ],),);
      });

      task.onComplete.then((taskDone){

firebaseStorageRef.getDownloadURL().then((result) {
 serviceCreator.addService(_price + prefs.getString('currencyCode'), 
prefs.getString('serviceCategoryName'), _serviceProvided[0].toUpperCase() + _serviceProvided.substring(1,), 
result.toString(), prefs.getString('uid'), 
'N/A', false, isVideo, _description, false, _website, shippingAdress, 
prefs.getString('subCategory'), _price, _timeTaken,
prefs.getString('countryCode'),'servicesfeed',
prefs.getString('location'),prefs.getString('phoneNumber'),
prefs.getDouble('long'),prefs.getDouble('lat'),
prefs.getString('profilePicture'),
prefs.getString('fullName'),
docID
).then((val){
  print('Hulk hogan');
  print(val);
  if(val == 1){
    Navigator.of(context, rootNavigator: true).pop('dialog');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminSuccessWidget()));
  }else if(val == 443){
     Fluttertoast.cancel();
          showDialog(context: context,builder: (BuildContext context){
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
                    title: Text('Account deactived'),
                    content: Text('Upgrade to a premium account with just \$27.26 only. Contact support to get started'),actions: <Widget>[
                    FlatButton(child: Text('OK'),onPressed: (){
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },)
                  ],);
                });

  }else{
     Fluttertoast.cancel();
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

}).catchError((onError){
   Fluttertoast.cancel();
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
});

});
      });

       });
}


sendToUsersSegment() async {
 SharedPreferences prefs = await SharedPreferences.getInstance();
String url = 'https://onesignal.com/api/v1/notifications';
Map<dynamic, dynamic> body = {
'app_id': '0a2fc101-4f5a-44c2-97b9-c8eb8f420e08',
'contents': {"en": "Stories Videos"},
'included_segments': ["All"],
'headings': {"en": "${prefs.getString('fullName')} shared a new style"},
'data': {"type": "new-videos"},
 "small_icon": "@mipmap/ic_launcher",
 "large_icon": "@mipmap/ic_launcher"
}; // 'small_icon': '' ... final response =
  await http.post(url,
body: json.encode(body),
headers: {HttpHeaders.authorizationHeader: "Basic OThhY2RlNTEtZTE5YS00Y2E2LWE3NWUtYTUwOWY0MTJmNzIz",
"accept": "application/json",
"content-type": "application/json"
}
);
}



  void _settingModalBottomSheet(
      context) {
    showModalBottomSheet(backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 265.0,
            color: Colors.transparent,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
             Container(margin: EdgeInsets.all(8.0),
              width: 150.0,child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                     Icon(EvaIcons.image),
                      Text('Upload Photo',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  onPressed: () async {
             if(!_formKey.currentState.validate()){
             return null;
             }
             _formKey.currentState.save();
               uploadPhoto(false);
                  },
                  color: Colors.white,
                  padding: EdgeInsets.all(9.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),
            ),

            Container(margin: EdgeInsets.all(8.0),
              width: 150.0,child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                     Icon(EvaIcons.filmOutline),
                      Text('Upload Video',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  onPressed: () async {
      _formKey.currentState.save();
      uploadVideo(true);
      },
                  color: Colors.white,
                  padding: EdgeInsets.all(9.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),
            ),

Container(margin: EdgeInsets.all(8.0),
              width: 200.0,child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                     Icon(EvaIcons.creditCard,color: Colors.yellow[800],),
                      Text(' Subscribe for Premium',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  onPressed: () {
               _launchURL('clicks');

                  },
                  color: Colors.white,
                  padding: EdgeInsets.all(9.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),
            ),
            Container(margin: EdgeInsets.all(8.0),
              width: 120.0,child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                     Icon(EvaIcons.archiveOutline),
                      Text(' My Office',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyOffice()));

                  },
                  color: Colors.white,
                  padding: EdgeInsets.all(9.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),
            )
              ],
            ),
          );
        });
  }



  Widget _buildTimeTextField() {
    return TextFormField(
      inputFormatters: [
                  LengthLimitingTextInputFormatter(50)
                ],
        textCapitalization: TextCapitalization.words,
        maxLines: 2,
        decoration: InputDecoration(labelText: 'Time Taken / Number of items'),
        onSaved: (String value) {
          _timeTaken = value;
        });
  }

  Widget _buildPriceTextField() {
    return TextFormField(
        maxLines: 2,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Price'),
        onSaved: (String value) {
          _price = value.toString();
        });
  }



  Widget _buildDescriptionTextField() {
    return TextFormField(onChanged: (value){
if(value.length > 1000){
            setState(() {
              hasExceeded = true;
            });
          }
    },
 inputFormatters: [
                  LengthLimitingTextInputFormatter(1002)
    ],
       textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          errorText: hasExceeded ? 'Description must not exceed 1002 charaters': null,
          labelText: 'Description'),
        onSaved: (String value) {
          _description = value;
        });
  }




  Future onSelectNotification(String payload) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsWidget()));
  }

  Future _showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'notifier_id', 'Service Request', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New service request',
      'Tap to to answer',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }


  void initState() {
   
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    fetchTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return Theme(child: SafeArea(child: GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        body:  Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding:
              EdgeInsets.symmetric(horizontal: targetPadding / 2),
             child: Column(
               children: <Widget>[
                  _buildServiceProvidedTextField(),
                SizedBox(height: 14.0,),
                _buildTimeTextField(),
                _buildPriceTextField(),
                  SizedBox(height: 25.0,),
                _buildDescriptionTextField(),
                SizedBox(
                  height: 11.0,
                ),

                
                StreamBuilder(stream: Firestore.instance.
                collection('referalEngine').
                document('${isUid}').snapshots(),builder: (context, snapshot){

                  
                  if(!snapshot.hasData){
                    return Container(child: Text(''));
                  }

                  if(snapshot.data['isPremium'] == true){
                  var lastActivatedTime = DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data['timeStamp']));
                  var date1 = DateTime.utc(lastActivatedTime.year,lastActivatedTime.month,lastActivatedTime.day);
                  var now = Timestamp.now().toDate();
                  var diff = now.difference(date1);
                  var days = diff.inDays;
                    return days < 31 ? Column(children: <Widget>[
                      _buildWebsite(),
                      _buildLink()
                    ],) : Center(child: Text('Subscribe to re-enable adding links'),);
                  }else{
                    return Padding(child: RaisedButton(
                  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0))
),
            elevation: 0.0,
            
                  child: Padding(child: Text('ACCOUNT DISABLED',
                    style: TextStyle(color: Colors.white,
                        fontSize: 16.8,fontFamily: 'Comfortaa',fontWeight: FontWeight.w900)),padding: EdgeInsets.all(15.0),),

                  onPressed: (){
                _launchURL('clicks');
                  },
                  color: Colors.red[800],
                ), padding: EdgeInsets.all(8.6));
                  }
                },),
                 SizedBox(
                  height: 10.0,
                )
               ],
             ),
            ),
          ),),floatingActionButton:  FloatingActionButton(child:Icon(EvaIcons.cloudUploadOutline, color: Colors.white,), onPressed: (){
     _settingModalBottomSheet(context);
              },backgroundColor: Colors.blueAccent,),),

      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    ),),data: Theme.of(context).copyWith(
       // Set the transparency here
       primaryColor: Colors.blueAccent,
       //or any other color you want. e.g Colors.blue.withOpacity(0.5)
      ),);
  }
}