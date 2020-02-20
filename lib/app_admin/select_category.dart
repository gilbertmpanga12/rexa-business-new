import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../mainOps/countries.dart';

class _Categories {
  final String categoryName;
  final String categoryId;

  _Categories({this.categoryName, this.categoryId});
  factory _Categories.fromJson(Map<String, dynamic> json) {
    return _Categories(
        categoryName: json['categoryName'], categoryId: json['categoryId']);
  }
}



class SelectCategory extends StatefulWidget {
  final String phoneNumber;
  final String fullName;
  final String email;
  final String gender;
  final String location;
  final String profilePicture;
  final String uid;
  final String businessName;
  final String nationalId;
  final double longitude;
  final double latitude;
  final String serviceCategoryName;


  SelectCategory({this.profilePicture,
    this.location,this.fullName,this.phoneNumber,
    this.latitude,this.longitude,this.uid,
    this.serviceCategoryName,this.email,this.businessName,this.gender,this.nationalId});

  SelectCategoryState createState() =>  SelectCategoryState();
}

class SelectCategoryState extends State<SelectCategory>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String  _category = 'Salon&Spas';
  List<_Categories> categoriesFetched = List();
  String _uid;
  String _profilePicture;
  String _email;
  String _phoneNumber;
  String _fullName;
  String _defaultGender;
  String _location;
  String _businessName;
  String _nationalID;
  String subCategory;

  Widget _buildCategoryTextField() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('saloonCategory').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Center(child: CircularProgressIndicator(),);
          default:
            return ListView.separated(
              separatorBuilder: (context, i) => Divider(),
              itemBuilder: (context, index){
                return Padding(child: ListTile(
            // trailing: Icon(Icons.keyboard_arrow_right),
            title: new Text('${snapshot.data.documents[index]['categoryName']}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.8, fontFamily: 'Comfortaa'),), // ${snapshot.data.documents[index]['categoryName']}
            onTap: () {
_newTaskModalBottomSheet(context, '${snapshot.data.documents[index]['categoryName']}');
            },          
          ),padding: EdgeInsets.all(1.0),);
              },itemCount: snapshot.data.documents.length,
            );
        }
      },
    );
    }


 void _newTaskModalBottomSheet(context, String searchTerm){
   _category = searchTerm; // set category name
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0))
),
      context: context,
      builder: (BuildContext bc) {
          return  StreamBuilder(stream: Firestore.instance.
              collection('subcategories').where('categoryName',isEqualTo: '$searchTerm',)
             .snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);
                }
                return ListView.separated(itemBuilder: (context,index){
                return Padding(child: SizedBox(child: ListTile(
            // trailing: new Icon(EvaIcons.arrowIosForwardOutline,color: Colors.white,),
            title: new Text('${snapshot.data.documents[index]['subCatName']}', style: TextStyle(color: Colors.white,fontFamily: 'Comfortaa'),), // ${snapshot.data.documents[index]['categoryName']}
            onTap: () {
             subCategory = snapshot.data.documents[index]['subCatName'];
             Navigator.of(context, rootNavigator: true).pop();
            //  Toast.show('Please wait...', context,duration: 7, backgroundColor: Colors.green);
             _submitForm();
            },          
          ),height: 46.8,),padding: EdgeInsets.all(1.0),);
              },itemCount: snapshot.data.documents.length,
              separatorBuilder: (context,index) => Divider(color: Colors.transparent),);

              },);
          
      }
    );
}





  

  _submitForm() async {
  DateTime now = DateTime.now();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _uid = prefs.getString('uid');
      _profilePicture = prefs.getString('profilePicture');
      _email = prefs.getString('email');
      showDialog(context: context,builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
          content: Row(children: <Widget>[
          Container(child: CircularProgressIndicator(),margin: EdgeInsets.only(right: 10.0),),
          Container(child: Text('Processing...',style: TextStyle(fontSize: 17.0),),)
        ],),);
      });

      selectCurrencyCode.countryResolver(prefs.getString('countryCode')).then((currency){
        final Map<String, dynamic> service = {
        'phoneNumber': prefs.getString('phoneNumber'),
        'fullName': _fullName,
        'email': _email,
        'gender': _defaultGender,
        'location': _location,
        'profilePicture': 'https://firebasestorage.googleapis.com/v0/b/esalonbusiness-d3f3d.appspot.com/o/placeholder-profile_3.png?alt=media&token=b6fc7bba-1c2d-44bb-af53-c3d3693a55ca',
        'uid': _uid,
        'businessName': _businessName,
        'nationalId': _nationalID,
        'longitude': prefs.getDouble('long'),
        'latitude': prefs.getDouble('lat'),
        'serviceCategoryName':  _category,
        'countryCode': prefs.getString('countryCode') ?? 'UG',
        'subCategory': subCategory
      };
      print(service);
      prefs.setString('currencyCode', currency);
      prefs.setString('phoneNumber', _phoneNumber);
      prefs.setString('serviceCategoryName', _category);
      prefs.setString('paymentMethod', 'Card');
      prefs.setString('subCategory', '$subCategory');

      Firestore.instance.collection('paymentplan').document('${_uid}').setData({
            'uid': _uid,
            'email': _email,
            'phoneNumber': _phoneNumber != null ? _phoneNumber: 'Not Available',
            'fullName': _fullName,
            'isPremium': false,
            'total': 0,
            'percentile': 0,
            'countryCode': prefs.getString('countryCode'),
            'lastBalance': 0,
            'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
            'lastUpdated': 0,
            'currencyCode': currency,
            'totalInwords': ""
          }).then((results){

Firestore.instance.collection('saloonServiceProvider').document('${_uid}').setData({
        'fcm_token': prefs.getString('fcm_token'),
        'phoneNumber': prefs.getString('phoneNumber'),
        'fullName': _fullName,
        'email': _email,
        'gender': _defaultGender,
        'location': _location,
        'profilePicture': 'https://firebasestorage.googleapis.com/v0/b/esalonbusiness-d3f3d.appspot.com/o/avatar.png?alt=media&token=53503121-c01f-4450-a5cc-cf25e76f0697',
        'uid': _uid,
        'businessName': _businessName.isEmpty ? 'Not Available' : _businessName,
        'nationalId': _nationalID,
        'longitude': prefs.getDouble('long'),
        'latitude': prefs.getDouble('lat'),
         'serviceCategoryName':  _category,
         'rating': 1,
         'isPremium': false,
         'isTrial': true,
         'timestamp': DateTime.now().millisecondsSinceEpoch.toString(), // timestamp-fix
         'isRequested': false,
         'token': prefs.getString('token'),
         'countryCode': prefs.getString('countryCode'),
         'isAccountVerified': false,
         'businessRegistrationNumber': prefs.getString('registrationNumber') ?? 'Not Available',
         'currencyCode': currency,
         'raterComment': '',
         'subCategory': subCategory,
         'status_notifier': false,
      }).then((success){
prefs.setBool('isNewUser', false);
prefs.setBool('isSignedIn', true);

Firestore.instance.collection('referalEngine').document('${_uid}').setData({
  'uid': _uid,
  'phoneNumber': prefs.getString('phoneNumber'),
  'isPremium': true,
  'timeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
  'currencyCode': currency // timestamp-fix
}).then((referal){
Navigator.pushReplacementNamed(context, '/home');
});
      });

          });
      });


    }catch(err){
      print('My error rat!!!!');
      print(err);
      showDialog(context: context,builder: (BuildContext context){
        return AlertDialog(shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
          title: Text('Oops something went wrong'),
          content: Row(children: <Widget>[
            Container(child: Container(
              width: 200.0,
              child: Text('Please try again or contact support team',style: TextStyle(fontSize: 17.0),),),)
          ],),actions: <Widget>[
          FlatButton(child: Text('OK'),onPressed: (){
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },)
        ],);
      });
    }


  }


  void initState(){
    _uid = widget.uid;
    _profilePicture = widget.profilePicture;
    _email = widget.email;
    _phoneNumber = widget.phoneNumber;
    _fullName = widget.fullName;
    _defaultGender = widget.gender;
    _location  = widget.location;
    _profilePicture = widget.profilePicture;
    _uid = widget.uid;
    _businessName = widget.businessName;
    _nationalID = widget.nationalId;
    super.initState();
  }

  Widget build(BuildContext context){
    return Scaffold(
      body: _buildCategoryTextField(),
    appBar: AppBar(
        title: Text(
          'Pick Category',
          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontFamily: 'Comfortaa'),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 1.0,
      ),
    );
  }
}