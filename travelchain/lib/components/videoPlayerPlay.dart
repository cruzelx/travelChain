import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerComp extends StatefulWidget {
  @override
  _VideoPlayerCompState createState() => _VideoPlayerCompState();
}

class _VideoPlayerCompState extends State<VideoPlayerComp> {
   VideoPlayerController _controller;
    @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}