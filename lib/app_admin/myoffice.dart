import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';


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

class History {
  final String requestedSaloonService;
  final String timeStamp;
  final String priceRequested;
  final String requesteeName;
  History({this.requestedSaloonService, this.timeStamp,
    this.priceRequested, this.requesteeName});
  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      requesteeName: json['requesteeName'],
        requestedSaloonService: json['requestedSaloonService'],
        timeStamp: '${json['timeStamp']}',
        priceRequested: '${json['priceRequested']}');
  }
}



class MyOffice extends StatefulWidget {
  MyOfficeState createState() => MyOfficeState();
}
class MyOfficeState extends State<MyOffice>{
  String codeUnit;
  List<History> resultsFetched = List();
  bool requestPassed = false;
  bool requestFailed = false;
  Total _total ;
  Total _percentile;
  String _uid;


String numberSummerizer(int number){
  var num = number.toString();
if(num.length > 7){
return num[0] + 'M+';
}else{
return num;
}

}

String numberSummerizer2(String number){

if(number.length > 10){
return number[0] + '+';
}else{
return number;
}

}


void _settingModalBottomSheet(context) {
    showModalBottomSheet(elevation: 3.0,backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(height: 170.0,child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30.0),
            Container(margin: EdgeInsets.all(8.0),
              width: 120.0,child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                      Text('Mobile Money',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  onPressed: (){
                 _launchURL('clicks');

                  },
                  color: Colors.white,
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),
            ),
            Container(margin: EdgeInsets.all(10.0),
              width: 120.0,child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                      Text('Pay with Card',
                          style: TextStyle(color: Colors.black, 
                          fontWeight: FontWeight.w600))
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  onPressed: () {
                  _launchURL('other');
                  },
                  color: Colors.white,
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),
            ),
            
          ],),);
        });
  }

  fetchTotal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      final response = await http
          .get('https://young-tor-95342.herokuapp.com/api/get-provider-total/${prefs.get('uid')}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var payload = json.decode(response.body);
        if(mounted){
          setState(() {
            _total = payload;

            super.initState();
          });
        }
      }
    }catch(err){
      print(err);
    }
  }

  localStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('currencyCode ?>>>>>>>>>>>>>>>>>>>>>>************************');
    print('${prefs.getString('currencyCode')}');
    print('${prefs.getString('countryCode')}');
    if(mounted){
      setState(() {
        codeUnit = prefs.getString('currencyCode');
        _uid = prefs.getString('uid');
      });
    }
  }



  initState(){
    localStorage();
    fetchTotal();
    super.initState();
  }

  double paddingTitle = 67.0;

  fetchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      final response = await http.get(
          'https://young-tor-95342.herokuapp.com/api/get-provider-history/${prefs.getString('uid')}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('response for transaction');
        print(response.body);
       if(mounted){
         setState(() {
           resultsFetched = (json.decode(response.body) as List)
               .map((data) => new History.fromJson(data))
               .toList();
           requestPassed = resultsFetched.length > 0;
           requestFailed = requestPassed == false || resultsFetched.length == 0;
         });
       }

        return resultsFetched;
      } else {
        requestFailed = true;
//        errorMessage = response.body;
        throw Exception('Oops something wrong');
      }
    }catch(err){
      requestFailed = true;
    }
  }

Widget placeholder(context){
  return Container(
            height: 160.0,
            child: Column(
              children: <Widget>[
                Center(
                    child: Padding(
                      child: Text(
                        'My Office',
                        style: TextStyle(color: Colors.white, fontSize: 23.8,fontWeight: FontWeight.w900,fontFamily: 'Comfortaa'),
                      ),padding: EdgeInsets.only(top:22.0,),
                    )),
               SizedBox(height: 20.0,),

               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: <Widget>[
                   Column(
                     children: <Widget>[
                       Text('Income',style: TextStyle(color: Colors.white,fontSize: 17.0,fontWeight: FontWeight.w300),),
                       Text('0${codeUnit}',style: TextStyle(color: Colors.white,fontSize: 22.0,fontWeight: FontWeight.w700))
                     ],
                   ),
                   
                   Column(
                     children: <Widget>[
                       Text('To be paid', style: TextStyle(color: Colors.white,fontSize: 17.0,fontWeight: FontWeight.w300),),
                       Text('0${codeUnit}',style: TextStyle(color: Colors.white,fontSize: 22.0,fontWeight: FontWeight.w700))
                     ],
                   )
                 ],
               )
              ],
            ),
            color: Colors.black,
          );
}
 

 _launchURL(String activityType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = 'https://rexapay.firebaseapp.com/pay/${prefs.getString('uid')}/${prefs.getString('token')}/$activityType/${prefs.getString('fullName')}/${prefs.getString('countryCode')}/${prefs.getString('currencyCode')}/${prefs.getString('email')}/${prefs.getString('phoneNumber')}';
  if (await canLaunch(url)) {
    await launch(url, universalLinksOnly: true); // ,forceWebView: true,enableJavaScript: true
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
      floatingActionButton: FloatingActionButton(child: Icon(Icons.payment,color: Colors.white,),
      onPressed: (){
        _settingModalBottomSheet(context);
      },backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0.0,
        // actions: <Widget>[
        //   IconButton(icon: Icon(Icons.payment),onPressed: (){
        //     Navigator.push(context,MaterialPageRoute(builder: (context) => Payments() ));
        //   },tooltip: 'Clear fees',)
        // ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          StreamBuilder(builder: (context, snapshot){
            if(snapshot.hasError) return SizedBox.shrink();

            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                  return placeholder(context);
                  break;
              default:
                  return Container(
            height: 170.0,
            child: Column(
              children: <Widget>[
                Center(
                    child: Padding(
                      child: Text(
                        'My Office',
                        style: TextStyle(color: Colors.white, fontSize: 23.8,fontWeight: FontWeight.w900,fontFamily: 'Comfortaa'),
                      ),padding: EdgeInsets.only(top:22.0,),
                    )),
               SizedBox(height: 20.0,),

               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: <Widget>[
                   Column(
                     children: <Widget>[
                       Text('Income',style: TextStyle(color: Colors.white,fontSize: 17.0,fontWeight: FontWeight.w300),),
                       Text('${numberSummerizer(snapshot.data['total'])}${codeUnit}',
                       style: TextStyle(color: Colors.white,fontSize: 22.0,
                       fontWeight: FontWeight.w700),)
                     ],
                   ),
                   
                   Column(
                     children: <Widget>[
                       Text('To be paid', style: TextStyle(color: Colors.white,fontSize: 17.0,fontWeight: FontWeight.w300),),
                       Text('${numberSummerizer(snapshot.data['lastBalance'])}${codeUnit}',style: TextStyle(color: Colors.white,fontSize: 22.0,
                       fontWeight: FontWeight.w700))
                     ],
                   )
                 ],
               )
              ],
            ),
            color: Colors.black87,
          );
            }
            

          },stream: Firestore.instance.collection('paymentplan').document('${_uid}').snapshots(),),

       StreamBuilder(stream: Firestore.instance.collection('providerTransations')
       .where('serviceProviderId',isEqualTo: '${_uid}').where('transactionPassed',isEqualTo: true).snapshots(),builder: (context,snapshot){
        if(snapshot.hasError) return Center(child: Align(child: Text('Oops something went wrong.Try again'),alignment: Alignment.center,heightFactor: 16,),);
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
              return CircularProgressIndicator();
              break;
          default:
              return snapshot.data.documents.length >  0 ? new Expanded(
            child: ListView.separated(itemBuilder: (BuildContext context, int index){
              return Column(
                children: <Widget>[
                  new ListTile(
                    trailing: Text(
                      '${numberSummerizer2(snapshot.data.documents[index]['priceRequested'])}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 17.0),
   overflow: TextOverflow.clip,
  maxLines: 1
                    ),
                    title:  Text(
                      '${snapshot.data.documents[index]['requesteeName']}',
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: new Container(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: new Text(
                        '${snapshot.data.documents[index]['timeStamp']}', // date formater causing
                        style: new TextStyle(
                            color: Colors.grey, fontSize: 14.0),
                        softWrap: true,
                      ),
                    ),
                  )
                ],
              );
            },itemCount: snapshot.data.documents.length,separatorBuilder: (context, index) => Divider(),),
          ): Center(
        child: Padding(child: Text('You have not made any transactions'),padding: EdgeInsets.only(top: 150.0),),
    );
        }
       },)
          
        ],
      )
      
      );

  }
}