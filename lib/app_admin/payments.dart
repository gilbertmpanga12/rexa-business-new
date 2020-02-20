import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../mobilemoney.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Payments extends StatefulWidget{
PaymentsState createState() => PaymentsState();
}
class PaymentsState extends State<Payments> {

  _launchURL(String activityType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  final url 
  = 'https://rexapay.firebaseapp.com/pay/${prefs.getString('uid')}/${prefs.getString('token')}/$activityType/${prefs.getString('fullName')}/${prefs.getString('countryCode')}';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    Fluttertoast.showToast(
        msg: "Oops!, website not listed by service provider.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Billing',
          style: TextStyle(fontFamily: 'Comfortaa',fontWeight: FontWeight.w900,color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        elevation: 1.5,
      ),
      body: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20.0, left: 0, right: 20.0),
            child: Column(children: <Widget>[
//              SizedBox(height: 10.0,),
//              Center(child: Padding(padding: EdgeInsets.only(top:10.0,bottom: 10.0),child: Column(children: <Widget>[
//                Text('25%',style: TextStyle(fontSize: 26.0,fontWeight: FontWeight.bold,fontFamily: 'Comfortaa'),),
//               Padding(child:  Text('charged per successful transaction',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,fontFamily: 'Comfortaa',color: Colors.grey[500]),textAlign: TextAlign.center,),padding: EdgeInsets.only(top:7.0,bottom: 7.0,left: 20.0,right: 7.0),)
//              ],),)),

              InkWell(
                child: ListTile(trailing: Icon(Icons.chevron_right),
                  leading: Icon(
                      Icons.payment,
                      color: Colors.yellow[800]
                  ),
                  title: Text('Pay by MobileMoney',style: TextStyle(fontWeight: FontWeight.w600,)),


                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MobileMoneyWid()));
                },

              ),
              Divider(),
              InkWell(child: ListTile(trailing: Icon(Icons.chevron_right),
                leading: Icon(
                    Icons.monetization_on,
                    color: Colors.yellow[800]
                ),
                title: Text('Pay by Card',style: TextStyle(fontWeight: FontWeight.w600,)),


              ),onTap: (){
                _launchURL('main');
              },),
               Divider(),
              InkWell(child: ListTile(trailing: Icon(Icons.chevron_right),
                leading: Icon(
                    Icons.link,
                    color: Colors.yellow[800]
                ),
                title: Text('Pay for referral system',style: TextStyle(fontWeight: FontWeight.w600,)),


              ),onTap: (){
                _launchURL('clicks');
              },),


            ],),
          ))
    );
  }
}