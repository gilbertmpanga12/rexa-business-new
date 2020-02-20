import 'package:esalonbusiness/app_admin/help.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import './auth.dart';
import 'package:flutter/services.dart';
import './app_admin/admin_home.dart';
import './app_admin/welcome_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './terms_and_conditions.dart';
import './app_admin/admin_profile.dart';
import 'app_admin/admin_settings.dart';
import 'app_admin/default_shell.dart';
import 'app_services/auth_service.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

Future<void>main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
//   OneSignal.shared.init(
//   "0a2fc101-4f5a-44c2-97b9-c8eb8f420e08",
//   iOSSettings: {
//     OSiOSSettings.autoPrompt: false,
//     OSiOSSettings.inAppLaunchUrl: true
//   }
// );

// OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
// OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
// var status = await OneSignal.shared.getPermissionSubscriptionState();
// var playerId = status.subscriptionStatus.userId;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
   //var status = await OneSignal.shared.getPermissionSubscriptionState();
  //  var playerId = status.subscriptionStatus.userId;
  //    prefs.setString('fcm_token', playerId);



// OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
//   FlutterRingtonePlayer.playAlarm(volume: 0.5, looping: true,);
// });
  runApp(MyApp());
}


Widget getErrorWidget(BuildContext context, FlutterErrorDetails error) {
   return Scaffold(body:  Container(margin: EdgeInsets.only(top: 200.0),child: Center(
     child: Column(
       children: <Widget>[
         Padding(child: Column(children: <Widget>[
Icon(EvaIcons.wifiOff,size: 50.0,color: Colors.grey[500],),
     Text(
          
       "Checking network connection...",
       style: Theme.of(context).textTheme.title.copyWith(color: Colors.black, fontFamily: 'Caveat',fontSize: 25.0),textAlign: TextAlign.center,
     )
         ],),padding: EdgeInsets.all(28.0),),
     FlatButton(child: Padding(padding: EdgeInsets.only(top:13.5,bottom: 13.5,left:25.5,right: 25.5),child: Text('OK',
     style: TextStyle(color: Colors.white, fontFamily: 'NunitoSans',fontWeight: FontWeight.w700))),onPressed: (){
      //  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewList()));
            SystemNavigator.pop();
     
     },color: Colors.blue[600],shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)))
       ],
     ),
   )),backgroundColor: Colors.white,);
 }



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rexa Business',
      theme: ThemeData(primarySwatch: Colors.yellow,
          fontFamily: 'NunitoSans',accentColor: Colors.yellow[800],brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
//      home: SignIn() ,
builder: (BuildContext context, Widget widget) {
         ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
           return getErrorWidget(context, errorDetails);
         };

         return widget;
},
    routes: {
        '/': (BuildContext context) => ViewSwitcher(),
        '/home': (BuildContext context) => AdminHome(),
        '/welcome': (BuildContext context) => WelcomeAdmin(),
        '/settings': (BuildContext context) => ProfileWidget(),
        'settings-2':(BuildContext context) => AdminSettings(),
        '/help':(BuildContext context) => HelpWid()
        // '/success': (BuildContext context) => AdminSuccessWidget(),
        // '/error': (BuildContext context) => AdminSuccessWidget()
    },
    );
  }
}

class ViewSwitcher extends StatefulWidget {

  @override
  ViewSwitcherState createState() => ViewSwitcherState();

}


class ViewSwitcherState extends State<ViewSwitcher>{
  bool isNew;
  bool isNewUser;
  
  void checkIfDeviceRegistered() async {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    setState(() {
    isNew = prefs.getBool('isSignedIn');
    isNewUser = prefs.getBool('isNewUser');
    });
  }

  




  @override
  void initState(){
  checkIfDeviceRegistered();
super.initState();
  }


  @override
  Widget build(BuildContext context){
    return StreamBuilder(stream: authService.user,builder: (context,snapshot){
     switch(snapshot.connectionState){
       case ConnectionState.waiting: 
       return DefaultHome();
       break;
       default:
       if (snapshot.hasData && isNew == true) {
        return  AdminHome();
      }else if(snapshot.hasData && isNewUser == true){
        return  TermsWid();
      }else {
        return SignIn();
      }
     }

    },);
  }


}
