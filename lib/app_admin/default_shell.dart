import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import './admin_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class DefaultHome extends StatefulWidget {
  @override
  DefaultHomeState createState() => DefaultHomeState();
}

class DefaultHomeState extends State<DefaultHome> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 

Widget mainviewSwap(){
  return TabBarView(
            children: <Widget>[
              Center(child: Container(height: 60.0,width: 60.0,child: CircularProgressIndicator(),),),
              Center(child: Container(height: 60.0,width: 60.0,child: CircularProgressIndicator(),),)
            ],
          );
}
 





  initState() {
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
              fontFamily: 'Meriada',
              fontWeight: FontWeight.w800,fontSize: 18.5),),
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
            Icon(Icons.notifications_active,color: Colors.black87,size: 30.0)
          ],
              iconTheme: IconThemeData(color: Colors.black)
          ),
          body: mainviewSwap(),

        ),

    ) ,),onWillPop: () async{ 
     SystemNavigator.pop();
    return false;
    });
  }
}
