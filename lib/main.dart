import 'package:esalonbusiness/app_admin/help.dart';
import 'package:esalonbusiness/app_admin/myoffice.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import './auth.dart';
import 'package:flutter/services.dart';
import './app_admin/admin_home.dart';
import './app_admin/welcome_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './terms_and_conditions.dart';
import './app_admin/admin_profile.dart';
import 'app_admin/admin_settings.dart';
import 'app_services/auth_service.dart';
import 'globals/configs.dart';


Future<void>main() async {
     // for IOS -> 043cf2de-40cc-4010-b431-4e02a950f75f- Business
   // for Android -> 01d9552f-a5c7-49a1-bf05-6886d9ccc944 -> User
   // for New Android  -> 306a55a3-92f5-4aac-9cb5-21fff19320e5

  WidgetsFlutterBinding.ensureInitialized();
  
  OneSignal.shared.init(
  Configs.appIdBusinessAndroidOnesignal,
  iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: true
  }
);

OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
// var status = await OneSignal.shared.getPermissionSubscriptionState();
// var playerId = status.subscriptionStatus.userId;

/*
OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
	// will be called whenever the permission changes
	// (ie. user taps Allow on the permission prompt in iOS)
});
OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
	// will be called whenever the subscription changes 
	//(ie. user gets registered with OneSignal and gets a user ID)
});
OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {
	// will be called whenever then user's email subscription changes
	// (ie. OneSignal.setEmail(email) is called and the user gets registered
});
*/



OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
//  Feedback.forTap(context);
FlutterRingtonePlayer.playAlarm(volume: 0.5, looping: true,);
});

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
        '/help':(BuildContext context) => HelpWid(),
        '/my-office': (BuildContext context) => MyOffice()
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
      if (snapshot.hasData && isNew == true) {
        return  AdminHome();
      }else if(snapshot.hasData && isNewUser == true){
        return  TermsWid();
      }else {
        return SignIn();
      }
    },);
  }


}