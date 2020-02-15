import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelchain/Services/fetchAllChallenges.dart';
import 'package:travelchain/Services/fetchDescription.dart';
import 'package:travelchain/Services/getVideoUrls.dart';
import 'package:travelchain/components/chewieListItem.dart';
import 'package:travelchain/components/videoRecoerder.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VerifyVideos extends StatefulWidget {
  @override
  _VerifyVideosState createState() => _VerifyVideosState();
}

class _VerifyVideosState extends State<VerifyVideos> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  final globalKey = GlobalKey<ScaffoldState>();
  final bool looping = true;
  bool isloading = true;
  bool isPageLoaded = false;
  List<String> _videoUrls = [];
  List<int> _vid = [];
  List<int> _cid = [];
  List<int> _uid = [];
  List<String> _titles = [];
  List<bool> _isVerified = [];

  int sUid=0;

  Future<int> getUidFromPref() async {
    SharedPreferences uid = await SharedPreferences.getInstance();
    return uid.getInt("uid");
  }

  Future<GetVideoUrls> getVideoUrls() async {
    final res = await http
        .get("https://travelchain.herokuapp.com/giveVideoUrls?uid=$sUid")
        .then((value) {
      int len = json.decode(value.body).length;
      print(len);
      if (len > 0) {
        for (int i = 0; i < len; i++) {
          var videoUrl = GetVideoUrls.fromJson(json.decode(value.body)[i]);
          print(videoUrl.viewed);
          print(json.decode(value.body)[i]);
          if (!videoUrl.viewed) {
            _videoUrls.add("https://gateway.ipfs.io/ipfs/" + videoUrl.vhash);
            _vid.add(videoUrl.vid);
            _cid.add(videoUrl.cid);
            _uid.add(videoUrl.uid);
            _isVerified.add(false);
            fetchDescription(videoUrl.cid);
          }
        }
      }
      globalKey.currentState.showSnackBar(SnackBar(
        content: Text("Video Has Been Loaded..."),
      ));
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  Future<FetchDescription> fetchDescription(int cid) async {
    final res = await http
        .get("https://travelchain.herokuapp.com/challenge?cid=$cid")
        .then((value) {
      var challenge = FetchDescription.fromJson(json.decode(value.body));
      _titles.add(challenge.name);
      setState(() {});
    }).catchError((e) {});
  }

  verifyVideo(int vid, int cid, int uid) async {
    final res = await http
        .get(
            "https://travelchain.herokuapp.com/verifyVideo?vid=$vid&cid=$cid&verifierid=$sUid&userid=$uid")
        .then((value) {
      globalKey.currentState
          .showSnackBar(SnackBar(content: Text("Video has been verified :)")));
    }).catchError((e) {
      globalKey.currentState.showSnackBar(
          SnackBar(content: Text("Error during verification :(")));
    });
  }

  runInitially() async {
    sUid = await getUidFromPref();
    getVideoUrls();
  }

  // _playVideos(String url) async {
  //   _videoPlayerController = VideoPlayerController.network(url);
  //   _chewieController = ChewieController(
  //       videoPlayerController: _videoPlayerController,
  //       aspectRatio: _videoPlayerController.value.aspectRatio,
  //       autoInitialize: true,
  //       looping: looping,
  //       errorBuilder: (context, errorMessage) {
  //         return Center(
  //           child: Text(errorMessage, style: TextStyle(color: Colors.white)),
  //         );
  //       });
  //   print("alex");
  //   print(_videoPlayerController.value.aspectRatio);
  // }

  @override
  void initState() {
    super.initState();
    runInitially();
    setState(() {
      isPageLoaded = true;
      isloading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // color: Colors.pinkAccent,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: (isPageLoaded && _videoUrls.length > 0)
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _videoUrls.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: (!isloading)
                          ? Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(_titles[index],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.0)),
                                ),
                                ChewieListItem(
                                  videoPlayerControllers:
                                      new VideoPlayerController.network(
                                          _videoUrls[index]),
                                ),
                                SizedBox(height: 5.0),
                                RaisedButton(
                                  onPressed: () {
                                    verifyVideo(
                                        _vid[index], _cid[index], _uid[index]);
                                    setState(() {
                                      _isVerified[index] = true;
                                    });
                                  },
                                  child: (!_isVerified[index])
                                      ? Text(
                                          "Verify",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          "Verified",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                              ],
                            )
                          : Center(child: CircularProgressIndicator()),
                    );
                  })
              : Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Loading videos to verify..."),
                      SizedBox(
                        width: 25.0,
                      ),
                      SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: Center(child: CircularProgressIndicator())),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
