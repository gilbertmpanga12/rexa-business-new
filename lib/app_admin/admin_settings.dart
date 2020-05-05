import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mainOps/countries.dart';
import './admin_home.dart';

class AdminSettings extends StatefulWidget{
  AdminSettingsState createState() => AdminSettingsState();
}
class AdminSettingsState extends State<AdminSettings>{

String _defaultPaymentMethod = 'Fitness & Aerobics';
String processing = 'OK';
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
String _defaultCode = 'GB';
String subCategory;

  Widget _buildGenderTextField() {
    return DropdownButtonFormField(decoration: InputDecoration(icon: Icon(Icons.payment,color: Colors.yellow[800])),
      value: _defaultPaymentMethod,
      items: <String>['Fitness & Aerobics',
      'Nail Care', 'Make up Studios', 
      'Botiques', 'Cosmetics Shops',
      'Hair dressing & Hair cuts',
      'Fashions and Designs','Massage'].map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String newValue) {

        if(mounted){
          setState(() {
            _defaultPaymentMethod = newValue;
          });
        }

      },);
  }


  void _newTaskModalBottomSheet(context){
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0))
),
      context: context,
      builder: (BuildContext bc){
          return  StreamBuilder(stream: Firestore.instance.
              collection('saloonCategory')
             .snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);
                }
                return Column(children: <Widget>[
                  SizedBox(height: 15.0,),
                  Center(child: Padding(child: Text("PICK NEW CATEGORY",
                  style: TextStyle(fontWeight: FontWeight.bold, color:Colors.white),),
                  padding: EdgeInsets.all(8.0),),),
                  Expanded(child: ListView.separated(itemBuilder: (context,index){
                return Padding(child: Container(height: 50.0,child: ListTile(
            //  trailing: new Icon(EvaIcons.arrowIosForwardOutline,color: Colors.white),
            title: new Text('${snapshot.data.documents[index]['categoryName']}',style: TextStyle(fontSize: 17.0, color: Colors.white),), // ${snapshot.data.documents[index]['categoryName']}
            onTap: () {
             subCategory = snapshot.data.documents[index]['categoryName'];
            // Navigator.of(context, rootNavigator: true).pop();
            //  Toast.show('Please wait...', context,duration: 7, backgroundColor: Colors.green);
            // Navigator.of(context, rootNavigator: true).pop();
            subCat(context, '$subCategory');
            },          
          ),),padding: EdgeInsets.all(6.0),);
              },itemCount: snapshot.data.documents.length,
              separatorBuilder: (context,index) => Divider(color: Colors.transparent,),),)
                ],);

              },);
          
      }
    );
}

resetCategories(String subCategory, String _category) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString('subCategory', '$subCategory');
  prefs.setString('serviceCategoryName', _category);
}


void subCat(context, String searchTerm){
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0))
),
      context: context,
      builder: (BuildContext bc){
          return  Container(child: StreamBuilder(stream: Firestore.instance.
              collection('subcategories').where('categoryName',isEqualTo: searchTerm)
             .snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);
                }
                return ListView.separated(itemBuilder: (context,index){
                return Padding(child: Container(height: 35,child: ListTile(
            // leading: new Icon(EvaIcons.info),
            title: new Text('${snapshot.data.documents[index]['subCatName']}',style: TextStyle(fontSize: 17.0,color: Colors.white),), // ${snapshot.data.documents[index]['categoryName']}
            onTap: () {
             subCategory = snapshot.data.documents[index]['subCatName'];
             Navigator.of(context, rootNavigator: true).pop();
             resetCategories(subCategory,searchTerm);
             // Navigator.of(context, rootNavigator: true).pop();
             Fluttertoast.showToast(
        msg: "Updated!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
            },          
          ),),padding: EdgeInsets.all(2.0),);
              },itemCount: snapshot.data.documents.length,
              separatorBuilder: (context,index) => Divider(),);

              },),height:200);
          
      }
    );
}

  
  
@override
dispose(){
  Fluttertoast.cancel();
  super.dispose();
}
  



 

getCurrencyCode(String code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Fluttertoast.showToast(
        msg: "Processing...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 13,
        textColor: Colors.white,
        fontSize: 16.0
  );
   selectCurrencyCode.countryResolver(code).then((resp){
     Fluttertoast.showToast(
        msg: "Updated!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
    prefs.setString('currencyCode', resp);

   });
  //  Fluttertoast.cancel();

  }

  submitPaymentMethod() async{
    setState(() {
     processing = 'processing...';
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    Firestore.instance.collection('saloonServiceProvider')
    .document('${prefs.getString('uid')}').setData({
      'serviceCategoryName': _defaultPaymentMethod
    },merge: true).then((onValue){
      prefs.setString('serviceCategoryName','$_defaultPaymentMethod');
           Fluttertoast.showToast(
        msg: "Updated!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 13,
        textColor: Colors.green,
        fontSize: 16.0
  );
      setState(() {
      processing = 'OK';
    });

      // Navigator.of(context,rootNavigator: true).pop();
    }).catchError((onError){
      Fluttertoast.showToast(
        msg: "Oops!, website not listed by service provider.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
      setState(() {
      processing = 'OK';
    });
    });
    
  }

 


  Widget build(BuildContext context){
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontFamily: 'Comfortaa',fontWeight: FontWeight.w900,
          fontSize: 17,
          color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: true,
        elevation: 1.3,
      ),
      body: Form(
        key: _formKey,
        child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 13.0, left: 0, right: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                InkWell(
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                    trailing: Icon(Icons.edit,size: 18,),
                    leading: SizedBox(
                      width: 50.0,
                      child: Icon(
                        Icons.payment,
                        color: Colors.yellow[800],size: 29.0,
                    ),),
                    title: Text('Change Category',style: TextStyle(fontWeight: FontWeight.bold,)),


                  ),
                  onTap: (){
                  _newTaskModalBottomSheet(context);
                  },

                ),
                // Divider(indent: 10,)

              ],),
            )),
      )
    ),onWillPop: () async{
      Navigator.pop(context, MaterialPageRoute(builder: (context) => AdminHome()));
      return Future.value(false);
    },);
  }
}