import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './select_category.dart';



class _Categories {
  final String categoryName;
  final String categoryId;

  _Categories({this.categoryName, this.categoryId});
  factory _Categories.fromJson(Map<String, dynamic> json) {
    return _Categories(
        categoryName: json['categoryName'], categoryId: json['categoryId']);
  }
}


class NewEditAdmin extends StatefulWidget {
  @override
  NewEditAdminState createState() => NewEditAdminState();
}


class NewEditAdminState extends State<NewEditAdmin> {
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

  Widget _buildGenderTextField() {
    return DropdownButtonFormField(decoration: InputDecoration(icon: Icon(Icons.info,color: Colors.yellow[800])),
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

  Widget _buildFullNameField() {
    return TextFormField(
        maxLines: 2,
        decoration: InputDecoration(labelText: 'Full Name',icon: Icon(Icons.person,color: Colors.yellow[800],)),
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
        maxLines: 2,
        decoration: InputDecoration(labelText: 'Location',icon: Icon(Icons.location_on,color: Colors.yellow[800],)),
        onSaved: (String value) {
          _location = value[0].toUpperCase() + value.substring(1,);
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'Location required';
          }else{
            return null;
          }
        });
  }

  Widget _buildNationalIdField() {
    return TextFormField(
        maxLines: 2,
        decoration: InputDecoration(labelText: 'National ID',icon: Icon(Icons.card_membership,color: Colors.yellow[800],)),
        onSaved: (String value) {
          _nationalID = value;
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'National ID required';
          }else{
            return null;
          }
        });
  }


  Widget _buildBusinessNameField() {
    return TextFormField(
        maxLines: 2,
        decoration: InputDecoration(labelText: 'Business Name',icon: Icon(Icons.work,color: Colors.yellow[800],)),
        onSaved: (String value) {
          _businessName = value[0] + value.substring(1,);
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'Business Name required';
          }else{
            return null;
          }
        });
  }


  Widget countryTextField() {
    return DropdownButtonFormField(
        decoration:
            InputDecoration(icon: Icon(Icons.verified_user, color: Colors.yellow[800]),hintText: 'Choose country code'),
        value: _defaultCode,
        items: <DropdownMenuItem<String>>[
          DropdownMenuItem(
              value: '+1',
              child: SizedBox(child: Text('United States +1'),width: 200.0,)
          ),
          DropdownMenuItem(
              value: '+44',
              child: SizedBox(child: Text('United Kingdom +44'),width: 200.0,)
          ),
         DropdownMenuItem(
              value: '+256',
              child: SizedBox(child: Text('Uganda +256'),width: 200.0,)
          ),
           DropdownMenuItem(
              value: '+254',
              child: SizedBox(child: Text('Kenya +254'),width: 200.0,)
          ),
           DropdownMenuItem(
              value: '+255',
              child: SizedBox(child: Text('Tanzania +255'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+86',
              child: SizedBox(child: Text('China +86'),width: 200.0,)
          ),
    DropdownMenuItem(
              value: '+972',
              child: SizedBox(child: Text('Israel +972'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+93',
              child: SizedBox(child: Text('Afghanistan +93'),width: 200.0,)
          ),
          DropdownMenuItem(
              value: '+355',
              child: SizedBox(child: Text('Albania +355'),width: 200.0,)
          ),
          DropdownMenuItem(
              value: '+213',
              child: SizedBox(child: Text('Algeria +213'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+1 684',
              child: SizedBox(child: Text('AmericanSamoa +1684'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+376',
              child: SizedBox(child: Text('Andorra +376'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+244',
              child: SizedBox(child: Text('Angola +244'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+1 264',
              child: SizedBox(child: Text('Anguilla +1264'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+1268',
              child: SizedBox(child: Text('Antigua and Barbuda +1268'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+54',
              child: SizedBox(child: Text('Argentina +54'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+374',
              child: SizedBox(child: Text('Armenia +374'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+297',
              child: SizedBox(child: Text('Aruba +297'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+61',
              child: SizedBox(child: Text('Australia +61'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+43',
              child: SizedBox(child: Text('Austria +43'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+994',
              child: SizedBox(child: Text('Azerbaijan +994'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+1 242',
              child: SizedBox(child: Text('Bahamas +1 242'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+973',
              child: SizedBox(child: Text('Bahrain +973'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+880',
              child: SizedBox(child: Text('Bangladesh +880'),width: 200.0,)
          ),
          DropdownMenuItem(
              value: '+1 246',
              child: SizedBox(child: Text('Barbados +1 246'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+375',
              child: SizedBox(child: Text('Belarus +375'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+32',
              child: SizedBox(child: Text('Belgium +32'),width: 200.0,)
          ),
DropdownMenuItem(
              value: '+501',
              child: SizedBox(child: Text('Belize +501'),width: 200.0,)
          ),

],
        onChanged: (String newValue){
          setState(() {
            _defaultCode = newValue;
          });
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'Country code required';
          } else {
            return null;
          }
        });
  }



  Widget _buildTelephoneField() {
    return TextFormField(
        maxLines: 2,
        decoration: InputDecoration(labelText: 'Phone Number',icon: Icon(Icons.phone,color: Colors.yellow[800],)),
        onSaved: (String value) {
          _phoneNumber = value;
        },
        validator: (String value) {
          if (value.isEmpty) {
            return 'Full name required';
          }else{
            return null;
          }
        });
  }


  _submitForm() async {
    if(!_formKey.currentState.validate()){
      return null;
    }

    _formKey.currentState.save();

    if(_phoneNumber[0] == '0' && _phoneNumber.length == 10){
      _phoneNumber = _defaultCode + _phoneNumber.substring(1,);
    }else{
      _phoneNumber = _defaultCode + _phoneNumber;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uid = prefs.getString('uid');
    _profilePicture = prefs.getString('profilePicture');
    _email = prefs.getString('email');
    prefs.setString('businessName', _businessName);


    Navigator.push(context, MaterialPageRoute(builder: (context) =>  SelectCategory(phoneNumber: _phoneNumber,fullName:_fullName,email: _email,
      gender: _defaultGender,location:_location,profilePicture: _profilePicture,uid:_uid,
      businessName:_businessName,nationalId:_nationalID,longitude: prefs.getDouble('long'),
      latitude: prefs.getDouble('lat'),serviceCategoryName: _category,)));

  }


  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return WillPopScope(child: Scaffold(
      appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w700,fontFamily: 'NunitoSans'),textAlign: TextAlign.center,
          
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black87),
          centerTitle: true,
          elevation: 1.5

          
        ),
      body: Container(
      margin: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: ListView.builder(
          padding:
          EdgeInsets.symmetric(horizontal: targetPadding / 2),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index){
            return Column(
              children: <Widget>[
            _buildFullNameField(),
            SizedBox(height: 10.0,),
            _buildLocationField(),
            SizedBox(height: 25.0,),
            _buildGenderTextField(),
            SizedBox(
              height: 25.0,
            ),
          SizedBox(
            height: 25.0,
          ),
          countryTextField(),
            _buildTelephoneField(),
            SizedBox(
              height: 25.0,
            ),
            _buildNationalIdField(),
            SizedBox(
              height: 25.0,
            ),
            _buildBusinessNameField(),
            SizedBox(
              height: 25.0,
            ),

          ],
            );
          },
        ),
      ),

    ),bottomNavigationBar: FlatButton(onPressed: (){
      _submitForm();

    }, child: Padding(child: Row(
      children: <Widget>[
        Text('NEXT',
          style: TextStyle(color:Colors.yellow[800],fontSize: 29.0,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),

      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ),
      padding: EdgeInsets.only(top:11.0,bottom: 11.0),),color: Colors.black
    )
      ,),onWillPop: (){
      Navigator.popAndPushNamed(context, '/');
    },);
  }
}
