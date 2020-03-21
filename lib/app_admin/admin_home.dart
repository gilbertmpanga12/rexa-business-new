import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import './view_service.dart';
import './add_service.dart';
import './admin_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../app_services/auth_service.dart';
import './notifications.dart';
import 'package:flutter/services.dart';

import 'package:cached_network_image/cached_network_image.dart';
import './help.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './admin_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:url_launcher/url_launcher.dart';



class Photo{
  final String profilePicture;
  Photo({this.profilePicture});
  factory Photo.fromJson(Map<String, dynamic> json){
    return Photo(
        profilePicture : json['profilePicture']
    );
  }
}

class AdminHome extends StatefulWidget {
  @override
  AdminHomeState createState() => AdminHomeState();
}

class AdminHomeState extends State<AdminHome> {
  int counter = 1;
  String newPhoto;
  String displayName;
  String  _firebaseUID;
  int stopper = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();


  localStorageLoader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      newPhoto = prefs.getString('profilePicture');
      displayName =  prefs.getString('businessName');
      _firebaseUID  = prefs.getString('uid');
    });
  }


_launchURL() async {
  final url = 'https://play.google.com/store/apps/details?id=esalonuser.esalonuser.esalonuser';
  Clipboard.setData(ClipboardData(text: '$url'));
  print(url);
  if (await canLaunch(url)) {
    await launch(url, universalLinksOnly: true); // ,forceWebView: true,enableJavaScript: true
  } else {
  Fluttertoast.showToast(
        msg: "Oops!, website not listed by service provider.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos:3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

whatsapp(String payload) async {
if (await canLaunch('whatsapp://send?phone=$payload')) {
    await launch('whatsapp://send?phone=$payload', universalLinksOnly: true); // ,forceWebView: true,enableJavaScript: true
  } else {
  Fluttertoast.showToast(
        msg: "Oops!, website not listed by service provider.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos:3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

Widget helpLine() {
  return StreamBuilder(builder: (context, helpshot){
if(!helpshot.hasData){
  return Center(child: CircularProgressIndicator(),);
}
 return Center(
        child: Padding(
          child: Column(
            children: <Widget>[
              SizedBox(height: 55.0,),
            Padding(child: Text(
              'Please Contact Support for Account Activation',
              style: TextStyle(fontSize: 19.0,fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ), padding: EdgeInsets.only(left: 25.0,right: 25.0)),
              SizedBox(height: 18.0,),
              InkWell(
                onTap: (){
                  whatsapp("tel://${helpshot.data['telephone1']}");
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Image.asset('assets/whatsapp.png'),
                  Text('${helpshot.data['telephone1']}',style: TextStyle(fontSize: 20.0),)
                ]),
              ),
    SizedBox(height: 6.0,),
             InkWell(
               child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Icon(EvaIcons.phoneOutline),
                  Text('${helpshot.data['telephone2']}',style: TextStyle(fontSize: 20.0),)
                ]),
               onTap: (){
                 launch("tel://${helpshot.data['telephone2']}");
               },
             ),
              SizedBox(height: 6.0,),

              Text('OR'),
              InkWell(
                child: Text('${helpshot.data['email']}', style: TextStyle(fontSize: 18.0),),
                onTap: (){
                  launch("mailto:${helpshot.data['email']}");
                },
              )
            ],
          ),
          padding: EdgeInsets.all(26.0),
        ),
      );
  }, stream: Firestore.instance.collection('helpline').document('pTjwRpNTOd96FnJZ09D3').snapshots(),);
}

Widget mainviewSwap(){
  return StreamBuilder(builder: (context, snapshot){
if(snapshot.hasError){
  return Center(child: Center(child: Text('Check your internet connection'),),);
}
  switch(snapshot.connectionState){
    case ConnectionState.waiting: return new Center(child: CircularProgressIndicator(),);
    default:
      return snapshot.data['isAccountVerified'] ? TabBarView(
            children: <Widget>[CreateServiceWidget(),
            ViewServiceWidget()
            ],
          ) : Center(child: Column(children: <Widget>[
            
           helpLine()

          ],),);
  }


  }, stream: Firestore.instance.
  collection('saloonServiceProvider')
  .document('$_firebaseUID').snapshots(),);
}
 


  void destroyUserNew() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response =
    await http.get('https://viking-250012.appspot.com/api/destroy-new-user/${prefs.getString('isRegistered')}');
    if(response.statusCode == 200 || response.statusCode == 201){
      return null;
    }else{
      throw Exception('Oops something wrong');
    }
  }



  



  Widget _buildSideDrawer(BuildContext context) {

    return Container(width: 260.0, child: Theme(child: Drawer(
      
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
      DrawerHeader(
        margin: EdgeInsets.all(0),
      child: StreamBuilder(
                      stream: Firestore.instance.collection('saloonServiceProvider').document('${_firebaseUID}').snapshots(),
                      builder: (context, snapshot) {
                        print('$_firebaseUID');
                        if(!snapshot.hasData){
                          return Text('Loading...');
                        }
                        return ListView(children: <Widget>[
Align(
                          alignment: Alignment.centerLeft,
                          child: Container(height: 200.0,child:Column(
                            children: <Widget>[
                          GestureDetector(child: CircleAvatar(
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                          CachedNetworkImageProvider('${snapshot.data['profilePicture']}'),
                          radius: 50.0,
                        ),onTap: (){
                          // to be continued here
                          // Navigator.pop(context);
Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileWidget()));

                        },),

 Text(
    '${snapshot.data['fullName'].toString().length > 37 ? snapshot.data['fullName'].toString().substring(0,37) + '...' : snapshot.data['fullName']}',
    // overflow: TextOverflow.ellipsis,
    // softWrap: false,
    style: TextStyle(color: Colors.white, fontSize: 18.0,fontWeight: FontWeight.w600,height: 1.4)
  )
                              
                            ],
                          )),
                        )
                        ],);
                      }
                  ),
        decoration: BoxDecoration(
          color: Colors.transparent,
        )
    ),

     
      ListTile(
        leading: Icon(EvaIcons.settings,color: Colors.white,),
        title: Text('Settings',style: TextStyle(color: Colors.white),),
        onTap: () {
        //  Navigator.pop(context);
        // _scaffoldKey.currentState.widget.
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminSettings()));
          // Navigator.popAndPushNamed(context, '/settings');
        },
      ),
      ListTile(
        leading: Icon(EvaIcons.questionMarkCircle,color: Colors.white,),
        title: Text('Help', style: TextStyle(color: Colors.white),),
        onTap: () {
          // Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => HelpWid()));
        },
      ),
       ListTile(
        leading: Icon(EvaIcons.share,color: Colors.white,),
        title: Text('Join Rexa Users App',style: TextStyle(color: Colors.white),),
        onTap: () {
   _launchURL();
        },
      ),
          ListTile(
            leading: Icon(EvaIcons.logOutOutline,color: Colors.white,),
            title: Text('Log Out', style: TextStyle(color: Colors.white),),
            onTap: () {
              authService.signOut();
              Navigator.popAndPushNamed(context, '/');
            },
          )
          // contact email goes here below
        ],
      ),
    ), data: Theme.of(context).copyWith(
       // Set the transparency here
       canvasColor: Color.fromRGBO(57, 62, 70, 0.3) // 255,255,255
       //or any other color you want. e.g Colors.blue.withOpacity(0.5)
      ),));
  }

  tapNotification() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id', 'your channel name', 'your channel description',
    importance: Importance.Max, priority: Priority.High, ticker: 'ticker');// android 8 Fuck you
var iOSPlatformChannelSpecifics = IOSNotificationDetails();
var platformChannelSpecifics = NotificationDetails(
    androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
await flutterLocalNotificationsPlugin.show(
    0, 'New notification', 'You have a new service request', platformChannelSpecifics,
    payload: 'item x');
}

// IOS CONFIG
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context){
        /*
         => new CupertinoAlertDialog(
            title: new Text(title),
            content: new Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new SecondScreen(payload),
                    ),
                  );
                },
              )
            ],
          ),
        */
        return Text('Notification');
      }

    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => NotificationsWidget()),
    );
}




  initState() {
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
     if(result.notification.payload.rawPayload['title'].toString().contains('requested')){
 // to handle ringtones
   FlutterRingtonePlayer.stop();
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => NotificationsWidget()));
 } else {
   Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => AdminHome()));
 }
});
   localStorageLoader();
   print('${_firebaseUID}');
var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
var initializationSettingsIOS = new IOSInitializationSettings(
    onDidReceiveLocalNotification: onDidReceiveLocalNotification);
var initializationSettings = new InitializationSettings(
    initializationSettingsAndroid, initializationSettingsIOS);
flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: onSelectNotification);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

   

  Widget build(BuildContext context) {
    return WillPopScope(child: MaterialApp(

    title: 'Rexa Business',
    debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NunitoSans',
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          accentColor:Colors.yellow[800] ,iconTheme: IconThemeData(color: Colors.black),),
      home: DefaultTabController(

        length: 2,
        child: Scaffold(
          key: _scaffoldKey,
floatingActionButton: StreamBuilder(
                      stream: CloudFunctions.instance.
     getHttpsCallable(functionName: 'notifyServiceProvider').call({
       'serviceProviderID': '${_firebaseUID}'
     }).asStream(),
                      builder: (context, snapshot) {
                        print('LOOOOOOOOOOOOO');
                        print(_firebaseUID);
                        if(!snapshot.hasData){
                          return Container(child: Text(''),);
                        }
      try{
          if(snapshot.data['isRequested']){
          tapNotification();
          this.counter = 1;

          
       }

      }catch(err){
        print('XXC');
      }

                        return Container(child: Text(''),);

}),
          drawer: _buildSideDrawer(context),
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                    icon: new Icon(
                      EvaIcons.menu2Outline, // EvaIcons.menuOutline
                      size: 26.0,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  )),
              title:  Text('Rexa Business',style: TextStyle(color: Colors.black87,
              fontFamily: 'Monoton',
              fontWeight: FontWeight.w500,
              fontSize: 18.5),),
              bottom: TabBar(indicatorColor: Colors.blueAccent,
              unselectedLabelColor: Colors.black87,labelColor: Colors.blueAccent,indicatorWeight: 3,
                tabs: <Widget>[
                  Tab(
                    icon: Icon(EvaIcons.editOutline),
                    text: 'Create Service',
                  ),


                  Tab(
                    icon: Icon(EvaIcons.compassOutline),
                    text: 'Services',
                  )
                ],
              ),actions: <Widget>[
            // Using Stack to show Notification Badge
            StreamBuilder(stream: Firestore.instance.
            collection('saloonServiceProvider').document(_firebaseUID).snapshots() ,
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return  IconButton(icon: Icon(EvaIcons.bell,color: Color(0xFF383838),), onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => NotificationsWidget()));
                });
  
              }
              try{
                return snapshot.data['status_notifier'] ? Stack(
              children: <Widget>[
                new IconButton(icon: Icon(Icons.notifications_active,color: Colors.black87,size: 30.0), onPressed: () {
                  FlutterRingtonePlayer.stop();
                  Navigator.push(context,MaterialPageRoute(builder: (context) => NotificationsWidget()));
                }),
                Positioned(
                  right: 11,
                  top: 11,
                  child: GestureDetector(child: new Container(
                    padding: EdgeInsets.all(2),
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 27,
                      minHeight: 27,
                    ),
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.5,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ),onTap: (){
                    FlutterRingtonePlayer.stop();
                      Navigator.push(context,MaterialPageRoute(builder: (context) => NotificationsWidget()));
                  },),
                )
              ],
            ): IconButton(icon: Icon(Icons.notifications,color:  Color(0xFF383838),size: 30.0), onPressed: () {
                 FlutterRingtonePlayer.stop();
                  Navigator.push(context,MaterialPageRoute(builder: (context) => NotificationsWidget()));
                });
              }catch(e){
                FlutterRingtonePlayer.stop();
                return IconButton(icon: Icon(Icons.notifications, color: Colors.black87,size: 30.0), onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => NotificationsWidget()));
                });
              }
            },)
          ],
              iconTheme: IconThemeData(color: Colors.black)
          ),
          body: mainviewSwap(),

        ),

    ) ,),onWillPop:(){
     SystemNavigator.pop();
    print('Back');
    });
  }
}