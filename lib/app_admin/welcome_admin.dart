import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './select_category.dart';
import 'package:country_code_picker/country_code_picker.dart';


class _Categories {
  final String categoryName;
  final String categoryId;

  _Categories({this.categoryName, this.categoryId});
  factory _Categories.fromJson(Map<String, dynamic> json) {
    return _Categories(
        categoryName: json['categoryName'], categoryId: json['categoryId']);
  }
}


class WelcomeAdmin extends StatefulWidget {
  @override
  WelcomeAdminState createState() => WelcomeAdminState();
}


class WelcomeAdminState extends State<WelcomeAdmin> {
  String _defaultGender = 'Female';
  String _fullName;
  String _location;
  String _phoneNumber;
  String _email;
  String _profilePicture;
  String _uid;
  String _businessName;
  String _nationalID;
  String  _category = 'Spa,Salons & Cosmetics Shops';
  String _defaultCode = '+1';
  List<_Categories> categoriesFetched = List();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final checkbusiness = TextEditingController();
  
  String _registrationNo;


  Widget _buildGenderTextField() {
    return DropdownButtonFormField(decoration: InputDecoration(icon: Icon(Icons.info,color: Colors.blue[400])),
      value: _defaultGender,
      items: <String>['Female','Male'].map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String newValue) {
        if(mounted){
          setState(() {
            _defaultGender = newValue;
          });
        }

      },);
  }

  

  Widget showCountries(){
  return CountryCodePicker(
         onChanged: _onCountryChange,
         // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
         initialSelection: 'IT',
         favorite: ['+256','UG'],
         // optional. Shows only country name and flag
         showCountryOnly: false,
         // optional. aligns the flag and the Text left
         alignLeft: true,
       );
}

void _onCountryChange(CountryCode countryCode) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     this._defaultCode = countryCode.toString(); // +256
     prefs.setString('countryCode', countryCode.code); // UG
  }

  Widget _buildFullNameField() {
    return TextFormField(
        textCapitalization: TextCapitalization.words,
        maxLines: 2,
        decoration: InputDecoration(labelText: 'Full Name',icon: Icon(Icons.person,color: Colors.blue[400],)),
        onSaved: (String value) {
          _fullName = value[0].toUpperCase() + value.substring(1,);
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'Full name required';
          }else{
            return null;
          }
        });
  }

  Widget _buildLocationField() {
    return TextFormField(
        textCapitalization: TextCapitalization.words,
        maxLines: 2,
        decoration: InputDecoration(labelText: 'Location',icon: Icon(Icons.location_on,color: Colors.blue[400],)),
        onSaved: (String value) async{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          _location = value[0].toUpperCase() + value.substring(1,);
          prefs.setString('location', value);
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'Location required';
          }else{
            return null;
          }
        });
  }




  Widget _buildBusinessNameField() {
    return TextFormField(
      controller: checkbusiness,
        textCapitalization: TextCapitalization.words,
        maxLines: 2,
        decoration: InputDecoration(labelText: 'Business Name',icon: Icon(Icons.work,color: Colors.blue[400],)),
        onSaved: (String value) {
          _businessName = value;
        });
  }





  Widget _buildTelephoneField() {
    return TextFormField(
        maxLines: 2,
        decoration: InputDecoration(labelText: 'Phone Number',icon: Icon(Icons.phone,color: Colors.blue[400],)),
        onSaved: (String value) {
          _phoneNumber = value;
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'Phone number is required';
          } else if(value.length < 10){
            return 'Phone number must be 10 digits';
          }else{
            return null;
          }
        });
  }


  Widget _buildNiNField() {
    return TextFormField(
        maxLines: 2,
        decoration: InputDecoration(labelText: 'National ID / SSN ',icon: Icon(Icons.phone,color: Colors.blue[400],)),
        onSaved: (String value) {
         _nationalID = value;
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'NiN is required';
          } else if(value.length < 14){
            return 'National ID required and must 14 characters';
          }else{
            return null;
          }
        }, );
  }


Widget businessRegistrationNo() {
    return TextFormField(
        maxLines: 2,
        decoration: InputDecoration(labelText: 'Business Registration number',icon: Icon(EvaIcons.archive ,color: Colors.blue[400],)),
        onSaved: (String value) {
         _registrationNo = value;
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'Business registration number required';
          }else{
            return null;
          }
        });
  }



@override
dispose(){
  checkbusiness.dispose();
  super.dispose();
}

  _submitForm() async {
   if(!_formKey.currentState.validate()){
      return null;
    }

    _formKey.currentState.save();
     SharedPreferences prefs = await SharedPreferences.getInstance();

    
    prefs.setString('phoneNumber', _defaultCode + _phoneNumber.substring(1,));
    _uid = prefs.getString('uid');
    _profilePicture = prefs.getString('profilePicture');
    _email = prefs.getString('email');
    prefs.setString('businessName', _businessName);
    prefs.setString('registrationNumber', _registrationNo);
    //  prefs.setString('phoneNumber', _phoneNumber);


    Navigator.push(context, MaterialPageRoute(builder: (context) =>  SelectCategory(phoneNumber: _defaultCode + _phoneNumber.substring(1,),fullName:_fullName,email: _email,
      gender: _defaultGender,location:_location,profilePicture: _profilePicture,uid:_uid,
      businessName:_businessName,nationalId:'$_nationalID',longitude: prefs.getDouble('long'),
      latitude: prefs.getDouble('lat'),serviceCategoryName: _category,)));
  }


  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return WillPopScope(child: Scaffold(body: Form(
      key: _formKey,
      child:Container(
        margin: EdgeInsets.all(10.0),
        child: ListView.builder(
          padding:
          EdgeInsets.symmetric(horizontal: targetPadding / 2),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index){
            return Column(
              children: <Widget>[
                SizedBox(height: 38.0,),
                Container(
                  child: Text(
                    'Get started with your service provider account',
                    style: TextStyle(fontSize: 25.0),textAlign: TextAlign.start,
                  ),
                  margin: EdgeInsets.only(bottom: 15.0,top: 25.0,right: 16.0),
                ),
                _buildFullNameField(),
                SizedBox(height: 10.0,),
                _buildLocationField(),
                SizedBox(height: 50.0,),
                _buildGenderTextField(),

                SizedBox(
                  height: 25.0,
                ),
                 Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Padding(child: Text('Select country code',style: TextStyle(fontSize: 15.0,
                    fontWeight: FontWeight.bold),),padding: EdgeInsets.all(5.0),),
                  // Divider(),
                  showCountries(),
                  Divider()
                  ],),
                _buildTelephoneField(),
                
                SizedBox(
                  height: 25.0,
                ),
                _buildNiNField(),
                SizedBox(
                  height: 25.0,
                ),
                _buildBusinessNameField(),
                SizedBox(
                  height: 25.0,
                ),
                checkbusiness.value.text.length > 1 ? businessRegistrationNo() : SizedBox.shrink()
              ],
            );
          },
        ),

      ) ,
    ) ,bottomNavigationBar: FlatButton(onPressed: (){
      _submitForm();

    }, child: Padding(child: Row(
      children: <Widget>[
        Text('NEXT',
          style: TextStyle(color:Colors.white,fontSize: 29.0,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),

      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ),
      padding: EdgeInsets.only(top:11.0,bottom: 11.0),),color: Colors.blue[800]
    )
      ,),onWillPop: (){
      Navigator.popAndPushNamed(context, '/'); // to be fixed;
    },);
  }
}
