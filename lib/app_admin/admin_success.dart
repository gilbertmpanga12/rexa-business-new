import 'package:flutter/material.dart';
import './admin_home.dart';
class AdminSuccessWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 100),
            child: Column(
              children: <Widget>[
                SizedBox(height: 60.0,),
                Icon(Icons.check_circle_outline,
                    size: 60.0, color: Colors.yellow[800]),
                SizedBox(height: 17.0,),
                Text('Service Created!',
                    style: TextStyle(
                      fontSize: 30.0,
                    )),
                SizedBox(height: 9.0),
              
                SizedBox(height: 38.0,),
                Center(
                    child: Container(child: RaisedButton(padding: EdgeInsets.all(16.0),
                        onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => AdminHome()));
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),

                        ),shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),color: Colors.yellow[800]
                    ),width: 130.0,))
              ],
            ),
          )),
      backgroundColor: Colors.white,
    );
  }
}
