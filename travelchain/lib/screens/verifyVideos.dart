import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelchain/Services/fetchAllChallenges.dart';
import 'package:travelchain/Services/fetchDescription.dart';
import 'package:travelchain/components/chewieListItem.dart';
import 'package:travelchain/components/videoRecoerder.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;

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
  List<String> _videoUrls = [];
  List<int> _vid = [];
  List<int> _cid = [];
  List<String> _titles = [];

  verifyVideo(int vid, int cid) async {
    final res = await http
        .get("https://travelchain.herokuapp.com/verifyVideo?vid=$vid&cid=$cid")
        .then((value) {
      globalKey.currentState
          .showSnackBar(SnackBar(content: Text("Video has been verified :)")));
    }).catchError((e) {
      globalKey.currentState.showSnackBar(
          SnackBar(content: Text("Error during verification :(")));
    });
  }

  Future<GetAllChallenges> getAllChallenges() async {
    final res = await http
        .get("https://travelchain.herokuapp.com/getChallenges")
        .then((value) {
      final int len = json.decode(value.body).length;
      for (int i = 0; i < len; i++) {
        var challenge = GetAllChallenges.fromJson(json.decode(value.body)[i]);
        fetchChallengeDescription(challenge.cid,challenge);
        print(challenge.name);
      }
      setState(() {
        isloading = false;
      });
      print(_videoUrls);
      globalKey.currentState.showSnackBar(SnackBar(content: Text("Videos Loaded...")));
    }).catchError((e) {
      print(e);
    });
  }

  Future<FetchDescription> fetchChallengeDescription(int cid, GetAllChallenges challenge) async {
    final res = await http
        .get("https://travelchain.herokuapp.com/challenge?cid=$cid")
        .then((value) {
      var challengeDescription =
          FetchDescription.fromJson(json.decode(value.body));
      final int len = challengeDescription.submittedVideos.length;
      if (len > 0) {
        for (int i = 0; i < len; i++) {
          _videoUrls.add(challengeDescription.submittedVideos[i].videoURL);
          _vid.add(challengeDescription.submittedVideos[i].vid);
          _cid.add(challengeDescription.cid);
          _titles.add(challenge.name);
          print(_videoUrls);
        }
      }
    }).catchError((e) {
      print(e);
    });
    setState(() {
      
    });
  }

  runInitially() async {
    getAllChallenges();
  }

  _playVideos(String url) async {
    _videoPlayerController = VideoPlayerController.network(url);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoInitialize: true,
        looping: looping,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(errorMessage, style: TextStyle(color: Colors.white)),
          );
        });
    print("alex");
    print(_videoPlayerController.value.aspectRatio);
  }

  @override
  void initState() {
    super.initState();
    runInitially();
    
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
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _videoUrls.length,
              itemBuilder: (context, index) {
                return Card(
                  child: (!isloading)?Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_titles[index],style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ChewieListItem(
                        videoPlayerControllers:
                            new VideoPlayerController.network(
                                _videoUrls[index]),
                      ),
                      SizedBox(height: 5.0),
                      RaisedButton(
                        onPressed: () {
                          verifyVideo(_vid[index], _cid[index]);
                        },
                        child: Text(
                          "Verify",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ):Center(child: CircularProgressIndicator()),
                );
              }),
        ),
      ),
    );
  }
}
