import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelchain/components/videoRecoerder.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:progress_dialog/progress_dialog.dart';

class JoinedScreen extends StatefulWidget {
  final int id;
  final String name;
  JoinedScreen({@required this.id, @required this.name});
  @override
  _JoinedScreenState createState() => _JoinedScreenState();
}

class _JoinedScreenState extends State<JoinedScreen> {
  File _video;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  bool _isSelelcted = false;
  int sUid;

  Future<int> getUidFromPref() async {
    SharedPreferences uid = await SharedPreferences.getInstance();
    return uid.getInt("uid");
  }

  runInitially() async {
    sUid = await getUidFromPref();
  }

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    runInitially();
    print(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  _pickVideo() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    _video = video;
    _videoPlayerController = VideoPlayerController.file(_video);

    setState(() {
      _isSelelcted = true;
    });
    var isUploaded = uploadImageToServer(
        "https://travelchain.herokuapp.com/vidUpload?uid=$sUid&cid=${widget.id}",
        video);

    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoInitialize: true,
        looping: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(errorMessage, style: TextStyle(color: Colors.white)),
          );
        });
  }

  Future<bool> uploadImageToServer(String endPoint, File asset) async {
    // bool ret = false;
    // var byteData = await asset.readAsBytes();
    // List<int> imageData = byteData.buffer.asUint32List();

    // http.Response response =
    //     await http.post(endPoint, body: imageData).catchError((err) {
    //   print("error while uploading video file...");
    //   globalKey.currentState.showSnackBar(SnackBar(
    //     content: Text("Video upload unsuccessfull :)"),
    //   ));
    //   ret = false;
    // });
    // print(response.statusCode);
    // print(endPoint);
    // if (response.statusCode == 200) {
    //   ret = true;
    //   globalKey.currentState.showSnackBar(SnackBar(
    //     content: Text("Video was uploaded successfully :)"),
    //   ));
    //   print(endPoint);
    //   print(endPoint.split('?')[0]);
    // }
    // return ret;

    try {
      final url = Uri.parse(endPoint);
      final fileName = path.basename(asset.path);
      final bytes = asset.readAsBytesSync();
      print(fileName);

      var req = http.MultipartRequest('POST', url)
        ..files.add(new http.MultipartFile.fromBytes('videoFile', bytes,
            filename: fileName, contentType: new MediaType('video', 'mp4')));

      var res = await req.send();
      print(res.statusCode);
      print(res.stream.toList().then((value) => print(value)));
      if (res.statusCode == 200) {
        print("yahooooooooooooooooooooooooooooo");
        globalKey.currentState.showSnackBar(SnackBar(
          content: Text("Video was uploaded successfully :)"),
        ));
      } else {
        globalKey.currentState.showSnackBar(SnackBar(
          content: Text("Video wasn't uploaded successfully :("),
        ));
      }
    } catch (e) {
      globalKey.currentState.showSnackBar(SnackBar(
        content: Text("Error occurred unfortunately :("),
      ));
    }
    // final mimetypeData = lookupMimeType(asset.path);
    // final url = Uri.parse(endPoint);
    // final req = http.MultipartRequest('POST', url);
    // final video = await http.MultipartFile.fromPath('buffer', asset.path,filename: "videoFile",contentType: new MediaType('multipart','form-data'));
    // req.files.add(video);
    // print(video.contentType);
    // print(video.length);

    // try {
    //   final streamedResponse = await req.send();
    //   final response = await http.Response.fromStream(streamedResponse);
    //   if (response.statusCode == 200) {
    //     globalKey.currentState.showSnackBar(SnackBar(
    //       content: Text("Video was uploaded successfully :)"),
    //     ));
    //   } else {
    //     globalKey.currentState.showSnackBar(SnackBar(
    //       content: Text("Error occurred unfortunately :("),
    //     ));
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pickVideo();
        },
        child: Icon(Icons.videocam),
      ),
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: (!_isSelelcted)
          ? Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.video_library,
                      size: 100.0,
                      color: Colors.black54,
                    ),
                    Text("Add video")
                  ],
                ),
              ),
            )
          : Chewie(
              controller: _chewieController,
            ),
    );
  }
}
