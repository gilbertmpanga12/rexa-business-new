import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esalonbusiness/app_admin/admin_home.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpWid extends StatefulWidget {
  HelpWidState createState() => HelpWidState();
}

class HelpWidState extends State<HelpWid> {
  build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Help',
          style: TextStyle(color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w900,fontFamily: 'Comfortaa'),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: StreamBuilder(builder: (context, helpshot){
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
                  launch("tel://${helpshot.data['telephone1']}");
                },
                child: Text('${helpshot.data['telephone1']}',style: TextStyle(fontSize: 20.0),),
              ),

             InkWell(
               child:  Text('${helpshot.data['telephone2']}',style: TextStyle(fontSize: 20.0),),
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
  }, stream: Firestore.instance.collection('helpline').document('pTjwRpNTOd96FnJZ09D3').snapshots(),),
    ),onWillPop: () async {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome()));
      return Future.value(false);
    },);
  }
}
