import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoPlayerScreen extends StatefulWidget {
  final String videourl;
  VideoPlayerScreen({Key key, this.videourl}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  String _url;
  bool shouldShow = true;

  @override
  void initState() {
    _url = widget.videourl;

  // Create and store the VideoPlayerController. The VideoPlayerController
  // offers several different constructors to play videos from assets, files,
  // or the internet.
  _controller = VideoPlayerController.network(
  '${_url}',
  );

  // // Initialize the controller and store the Future for later use
  _initializeVideoPlayerFuture = _controller.initialize();

  // // Use the controller to loop the video
  _controller.setLooping(true);

  super.initState();
  }

  @override
  void dispose() {
  // Ensure you dispose the VideoPlayerController to free up resources
  
 _controller.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  body: FutureBuilder(
  future: _initializeVideoPlayerFuture,
  builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.done) {
  // If the VideoPlayerController has finished initialization, use
  // the data it provides to limit the Aspect Ratio of the Video
  return InkWell(

  child: Stack(
  fit: StackFit.expand,
  children: <Widget>[
  VideoPlayer(_controller),
  shouldShow  ?  Center(child: Icon(  Icons.play_circle_filled,
  color: Colors.white,size: 58.0,),): Text('')

  ],
  ),
  onTap: (){

  if (_controller.value.isPlaying) {
  if (_controller.value.isPlaying) {
  setState(() {
  shouldShow = true;
  });
  _controller.pause();
  } else {
  setState(() {
  shouldShow = true;
  });
  // If the video is paused, play it
  _controller.play();
  }
  _controller.pause();
  } else {
  setState(() {
  shouldShow = false;
  });
  // If the video is paused, play it
  _controller.play();
  }
  },
  );
  } else {
  // If the VideoPlayerController is still initializing, show a
  // loading spinner
  return Center(child: CircularProgressIndicator());
  }
  },
  ),
  );
  }
}