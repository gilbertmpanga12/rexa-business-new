import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatefulWidget {
  final String photoUrl;
  final String serviceName;

  ViewImage({this.photoUrl, this.serviceName});

  ViewImageState createState() => ViewImageState();
}

class ViewImageState extends State<ViewImage> {
  String imageUrl;
  String ServiceName;

  initState() {
    imageUrl = widget.photoUrl;
    ServiceName = widget.serviceName;
    super.initState();
  }

  build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${ServiceName[0].toUpperCase() + ServiceName.substring(
                  1,
                )}',
            style: TextStyle(color: Colors.black,fontFamily: 'Comfortaa',fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 1.5,
         
        ),
        body: PhotoView(imageProvider: NetworkImage('$imageUrl')));
  }
}
