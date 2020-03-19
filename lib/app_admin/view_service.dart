import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'dart:async';
import 'dart:convert';
// import 'package:transparent_image/transparent_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import './view_image.dart';
import '../video_widget.dart';

class CategoriesAll {
  final String time;
  final String price;
  final String serviceCategoryName;
  final String serviceOffered;
  final String uid;
  final String servicePhotoUrl;
  final String docID;
  final bool isVideo;
  CategoriesAll(
      {this.time,
      this.price,
      this.serviceOffered,
      this.serviceCategoryName,
      this.uid,
      this.servicePhotoUrl,
      this.docID, this.isVideo});

  factory CategoriesAll.fromJson(Map<String, dynamic> json) {
    return CategoriesAll(
        time: json['time'],
        price: '${json['price']}',
        serviceCategoryName: json['serviceCategoryName'],
        serviceOffered: json['serviceOffered'],
        uid: json['uid'],
        servicePhotoUrl: json['servicePhotoUrl'],
        docID: json['docID'],
        isVideo: json['isVideo']

    );
  }
}

class ViewServiceWidget extends StatefulWidget {
  String categoryType;
  ViewServiceWidget({this.categoryType});
  @override
  ViewListState createState() => ViewListState();
}

class ViewListState extends State<ViewServiceWidget> {
  List<CategoriesAll> resultsFetched = List();
  String _userId;
  bool showResults;
  bool isAbsent = false;
  bool isNetworkError = false;

  deleteUploadedFeed(String uid) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
            content: Row(
              children: <Widget>[
                Container(
                  child: CircularProgressIndicator(),
                  margin: EdgeInsets.only(right: 10.0),
                ),
                Container(
                  child: Text(
                    'Processing...',
                    style: TextStyle(fontSize: 17.0),
                  ),
                )
              ],
            ),
          );
        });

    Firestore.instance.collection('servicesfeed').document(uid).delete().then((onValue){
Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
              title: Text('Successfully'),
              content: Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      'Deleted upload',
                      style: TextStyle(fontSize: 17.0),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK',style: TextStyle(color: Colors.black87)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    fetchCategories();
                  },
                )
              ],
            );
          });
    }).catchError((onError){
showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))
),
              title: Text('Failed to delete'),
              content: Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      'Please try again or contact support team',
                      style: TextStyle(fontSize: 17.0),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK',style: TextStyle(color: Colors.black87),),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                )
              ],
            );
          });
    });
  }

  fetchCategories() async {
    try{
SharedPreferences prefs = await SharedPreferences.getInstance();
    print(_userId);
    print('${prefs.getString('uid')}');

    final response = await http.get(
        'https://young-tor-95342.herokuapp.com/api/fetch-feeds/${prefs.getString('uid')}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      
      setState(() {
        resultsFetched = (json.decode(response.body) as List)
            .map((data) => new CategoriesAll.fromJson(data))
            .toList();
        showResults = resultsFetched.length > 0;
        isAbsent = showResults == false;
      });

      return resultsFetched;
    } else {
      setState(() {
        isAbsent = true;
      });
      // throw Exception('Oops something wrong');
    }
    }catch(err){
print(err);
    }
  }

  void _settingModalBottomSheet(
      context, String uid, String imageUrl, String serviceName) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 120.0,
            color: Colors.transparent,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
               Container(
                 width: 140.0,
                 margin: EdgeInsets.only(left: 10.0),
                 child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                     Icon(Icons.delete),
                      Text('Delete Service',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  onPressed: () async {
            deleteUploadedFeed(uid);
                  },
                  color: Colors.white,
                  padding: EdgeInsets.all(9.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),),
                SizedBox(height: 10.0,),
                Container(
                 width: 140.0,
                 margin: EdgeInsets.only(left: 10.0),
                 child: RaisedButton(
                  child: Row(
                    children: <Widget>[
                     Icon(Icons.info,color: Colors.yellow[800],),
                      Text('View Image',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  onPressed: () async {
             Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewImage(
                                  photoUrl: imageUrl,
                                  serviceName: serviceName,
                                )));
                  },
                  color: Colors.white,
                  padding: EdgeInsets.all(9.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),),
                 SizedBox(height: 10.0,),
                // new ListTile(
                //   leading: new Icon(Icons.cancel),
                //   title: new Text('Cancel Call'),
                //   onTap: () {
                //     Navigator.of(context).pop();
                //   },
                // ),
              ],
            ),
          );
        });
  }

  String stringChopper(String word) {
    if (word.length > 16) {
      return word.substring(0, 16) + '...';
    } else {
      return word;
    }
  }


buildPostHeader({String serviceName, String price, String docID, 
String servicePhotoUrl, String serviceOffered}) {
    return ListTile(
              // leading: CircleAvatar(
              //   backgroundImage: CachedNetworkImageProvider('https://www.denofgeek.com/wp-content/uploads/2019/10/header_main_image_2.jpg?resize=768%2C432'),
              //   backgroundColor: Colors.grey,
              // ),
              title: GestureDetector(
                child: Text('$serviceName', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17.0,fontFamily: 'NunitoSans')),
                onTap: () {
                 _settingModalBottomSheet(
                        context,
                        docID,
                        servicePhotoUrl,
                        serviceOffered);
                },
              ),
              subtitle: Text('$price',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16.0,color: Colors.yellow[800])),
              trailing: InkWell(child: const Icon(Icons.more_vert),onTap: (){
                _settingModalBottomSheet(
                        context,
                        docID,
                        servicePhotoUrl,
                       serviceOffered);
              },),
            );
  }

    
  initState() {
    fetchCategories();
    super.initState();
  }



  @override
  dispose(){
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            '${resultsFetched.length > 0 ? 'Your Services' : ''}',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.9,
                color: Colors.grey[700]),
//            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          elevation: 0.0),
      body: resultsFetched.length > 0
          ? ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Padding(
  padding: new EdgeInsets.all(0.0),
  child:  Card(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
               
                Flexible(
                  fit: FlexFit.tight,
                  flex: 320,
                  child:  resultsFetched[index].isVideo ? VideoPlayerScreen(videourl: "${resultsFetched[index].servicePhotoUrl}",) :InkWell(
                    child: new Image.network(
                    "${resultsFetched[index].servicePhotoUrl}",
                    fit: BoxFit.cover,
                  ),
                  onTap: (){
 _settingModalBottomSheet(
                        context,
                        resultsFetched[index].docID,
                        resultsFetched[index].servicePhotoUrl,
                        resultsFetched[index].serviceOffered);
                  },
                  ),
                ),
                buildPostHeader(price: '${resultsFetched[index].price}',
                serviceName: '${ stringChopper(resultsFetched[index].serviceOffered)}',
                docID: resultsFetched[index].docID,serviceOffered: resultsFetched[index].serviceOffered,
                servicePhotoUrl: resultsFetched[index].servicePhotoUrl
                )
              ],
            ),)
  );
              },
//              padding: EdgeInsets.all(8.0),
              itemExtent: 320.0,
              itemCount: resultsFetched.length,
            )
          : isAbsent
              ? Center(
                  child: Text(
                    'You haven\'t added any services yet',
                    style: TextStyle(fontSize: 15.0),
                  ),
                )
              : isNetworkError
                  ? Center(
                      child: Text('Please check your network connection'),
                    )
                  : Center(child: CircularProgressIndicator(strokeWidth: 5.0)),
      backgroundColor: Colors.white,
    );
  }
}
