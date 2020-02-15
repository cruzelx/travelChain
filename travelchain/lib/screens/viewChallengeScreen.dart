import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelchain/Services/fetchDescription.dart';
import 'package:http/http.dart' as http;
import 'package:travelchain/Services/fetchUsers.dart';
import 'package:travelchain/components/chewieListItem.dart';
import 'package:video_player/video_player.dart';

class ViewChallengeScreen extends StatefulWidget {
  final int cid;
  ViewChallengeScreen({@required this.cid});
  @override
  _ViewChallengeScreenState createState() => _ViewChallengeScreenState();
}

class _ViewChallengeScreenState extends State<ViewChallengeScreen> {
  List<String> urls = [];
  String challengeName = "";
  String creatorName = "";
  String description = "";
  int challengeId = 0;
  int tokens = 0;

  bool isJoined = false;

  int sUid;

  bool isLoading = true;

  Future<int> getUserIdFromPref() async {
    SharedPreferences uid = await SharedPreferences.getInstance();
    return uid.getInt("uid");
  }

  Future<FetchDescription> fetchChallengeDescription() async {
    final res = await http
        .get("https://travelchain.herokuapp.com/challenge?cid=${widget.cid}")
        .then((value) {
      print(json.decode(value.body));
      print("run run run");
      var challengeDescp = FetchDescription.fromJson(json.decode(value.body));
      var len = challengeDescp.submittedVideos.length;
      print(len);
      for (int i = 0; i < len; i++) {
        urls.add(challengeDescp.submittedVideos[i].videoURL);
      }

      fetchUser(challengeDescp.creatoruid);
      setState(() {
        challengeName = challengeDescp.name;
        description = challengeDescp.description;
        tokens = challengeDescp.tokenprice;
        challengeId = challengeDescp.cid;
        isLoading = false;
      });
      print(urls);
    }).catchError((e) {});
  }

  Future<String> fetchUser(uid) async {
    final res = await http
        .get("https://travelchain.herokuapp.com/getUser?uid=$uid")
        .then((value) {
      var user = FetchUser.fromJson(json.decode(value.body));
      print(user.name);
      setState(() {
        creatorName = user.name;
      });
    }).catchError((e) {});
  }

  Future<dynamic> joinChallenge(int cid) async {
    print("user id: "+cid.toString());
    final res = await http
        .get(
            "https://travelchain.herokuapp.com/joinChallenge?uid=$sUid&cid=$cid")
        .then((value) {})
        .catchError((e) {
      // globalKey.currentState.showSnackBar(snackBar);
      print("Error Joining");
    });
  }

  runInitially() async {
    sUid = await getUserIdFromPref();
    fetchChallengeDescription();
  }

  @override
  void initState() {
    super.initState();
    runInitially();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          label: (!isJoined)?Text("+Join", style: TextStyle(fontSize: 16.0)):Text("Joined", style: TextStyle(fontSize: 16.0)),
          onPressed: () {
            joinChallenge(challengeId);
            setState(() {
              isJoined = true;
            });
          },
        ),
        appBar: AppBar(
          title: Text("Challenge"),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: (!isLoading)
                ? Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://scontent.fktm1-1.fna.fbcdn.net/v/t1.0-9/s960x960/61895741_1030831727110119_8215917200502947840_o.jpg?_nc_cat=102&_nc_ohc=hJzSKTrOgpUAX9-aN_s&_nc_ht=scontent.fktm1-1.fna&oh=fb4d08a533640f94828ad6f374a5a549&oe=5EC91B55"),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(creatorName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Row(
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(
                                        text: 'Prize: ',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "$tokens T",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                  color: Colors.black))
                                        ],
                                      ),
                                    ),
                                    // Text(
                                    //   "Prize: $tokenprice T",
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 25.0),
                                    // ),
                                  ],
                                )
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Text(creatorName),
                                    Text(
                                        "${DateFormat('MMMM d, y - kk:mm').format(DateTime.now())}"),
                                  ],
                                ),
                                // RaisedButton(
                                //     onPressed: () {
                                //       joinChallenge(sUid);
                                //     },
                                //     child: Text("+Join"))
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(challengeName,
                                  style: TextStyle(fontSize: 25.0)),
                              SizedBox(height: 30.0),
                              Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                description,
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              Divider(),

                              Text(
                                "Submitted Videos",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: urls.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ChewieListItem(
                                          videoPlayerControllers:
                                              new VideoPlayerController.network(
                                                  urls[index])),
                                    );
                                  })
                              // Text(descript),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Loading Challenge Descriptions..."),
                          SizedBox(
                            width: 25.0,
                          ),
                          SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child:
                                  Center(child: CircularProgressIndicator())),
                        ],
                      ),
                    ),
                  ),
          ),
        ));
  }
}
