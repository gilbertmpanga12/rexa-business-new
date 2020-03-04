import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardWid extends StatefulWidget {
  CardWidState createState() => CardWidState();
}

class CardWidState extends State<CardWid> {
  String _receiver;
  String _sender;
  String currencyCode = '';

  getCurrency() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currencyCode = prefs.getString('countryCode');
      print(currencyCode);
    });
  }

  initState(){
    getCurrency();
    super.initState();
  }


  Widget _buildSenderAmountTextField() {
    return TextFormField(
        maxLines: 1,
        decoration: InputDecoration(labelText: 'e.g 1$currencyCode',border: OutlineInputBorder(),),
        onSaved: (String value) {
          _sender = value;
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'Amount is required';
          }
        });
  }


//Widget _buildReceiverAmountTextField() {
//  return TextFormField(
//      enableInteractiveSelection: false,
//      focusNode: FocusNode(),
//      maxLines: 1,
//      decoration: InputDecoration(labelText: '+256785442776',border: OutlineInputBorder(),enabled: false,),
//      onSaved: (String value) {
//        _receiver = value;
//      },
//      validator: (String value) {
//        if (value.isEmpty) {
//          return 'Amount is required';
//        }
//      });
//}

  _submitForm() async{
    print('SENT!');
  }

  build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Card',
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontFamily: 'Comfortaa'),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 1.0,
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection('helpline').document('pTjwRpNTOd96FnJZ09D3').snapshots(),
            builder: (context, snapshot) {

              if(!snapshot.hasData){
                return Text('Loading...');
              }
              return Padding(
                child: ListView(children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 16.0,),
                      Center(
                        child: Padding(child: Text('For Card Payments, '
                            'clear bills via the above account number our support team to re-activate your account.',textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0,
                            fontWeight: FontWeight.w500,color: Colors.black87,fontFamily:'Comfortaa' ),),padding: EdgeInsets.all(5.8),),
                      ),
                      SizedBox(height: 20.0,),

                      Center(
                        child: Padding(
                          child: Text('${snapshot.data['accountnumber']}',style: TextStyle(fontSize: 23.3,fontFamily:'Comfortaa',fontWeight: FontWeight.w600,color: Colors.blue[900]),textAlign: TextAlign.center,),
                          padding: EdgeInsets.all(10.0),
                        ),
                      )


                    ],
                  )
                ],),
                padding: EdgeInsets.all(15.0),
              );
            }
        )
    );
  }
}
