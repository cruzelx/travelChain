import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:travelchain/Services/joinedChallenges.dart';
import 'package:travelchain/screens/joinedScreen.dart';
import 'package:http/http.dart' as http;

class JoinedTab extends StatefulWidget {
  @override
  _JoinedTabState createState() => _JoinedTabState();
}

class _JoinedTabState extends State<JoinedTab> {
  List<String> _events = [];
  List<int> _eventId = [];
  bool isLoading = true;
  int sUid;

  Future<int> getUidPrefData() async {
    SharedPreferences uid = await SharedPreferences.getInstance();
    return uid.getInt("uid");
  }

  Future<JoinedChallenge> getJoinedChallenges() async {
    final res = await http
        .get("https://travelchain.herokuapp.com/getJoinedChallenges?uid=$sUid")
        .then((value) {
      final int len = json.decode(value.body).length;
      print(len);

      for (int i = 0; i < len; i++) {
        var joinedChallenge =
            JoinedChallenge.fromJson(json.decode(value.body)[i]);
        print(joinedChallenge.cid);
        _events.add(joinedChallenge.name);
        _eventId.add(joinedChallenge.cid);
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {});
  }

  getJoinedChallenge() async {
    sUid = await getUidPrefData();
    getJoinedChallenges();
  }

  @override
  void initState() {
    super.initState();
    getJoinedChallenge();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: !isLoading
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 20, left: 10.0, right: 10.0, bottom: 10.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => JoinedScreen(
                                    id: _eventId[index], name: _events[index]),
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://scontent.fktm1-1.fna.fbcdn.net/v/t1.0-9/s960x960/61895741_1030831727110119_8215917200502947840_o.jpg?_nc_cat=102&_nc_ohc=hJzSKTrOgpUAX9-aN_s&_nc_ht=scontent.fktm1-1.fna&oh=fb4d08a533640f94828ad6f374a5a549&oe=5EC91B55"),
                              ),
                              title: Text("${_events[index]}"),
                              subtitle: Text(
                                  "${DateFormat('MMMM d, y - kk:mm').format(DateTime.now())}"),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            )
          : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Loading joined challenges..."),
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
    );
  }
}
