import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelchain/Services/fetchUsers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int sUid;
  String _username;
  int _tokens;
  bool _isLoading = true;
  Future<int> getUidFromPref() async {
    SharedPreferences uid = await SharedPreferences.getInstance();
    return uid.getInt("uid");
  }

  Future<FetchUser> getUserDetails(int sUid) async {
    final res = await http
        .get("https://travelchain.herokuapp.com/getUser?uid=$sUid")
        .then((value) {
      var user = FetchUser.fromJson(json.decode(value.body));
      print(user);
      setState(() {
        _username = user.name;
        _tokens = user.tokens;
        _isLoading = false;
      });
    }).catchError((e) {});
    setState(() {});
  }

  runInitially() async {
    sUid = await getUidFromPref();
    getUserDetails(sUid);
  }

  @override
  void initState() {
    super.initState();
    runInitially();
  }

  @override
  Widget build(BuildContext context) {
    return (!_isLoading)
        ? Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {},
              label: Text("Logout"),
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.exit_to_app),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: AppBar(
              centerTitle: true,
              title: Text("Profile"),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.notifications), onPressed: () {})
              ],
              bottom: PreferredSize(
                preferredSize:
                    Size.fromHeight(MediaQuery.of(context).size.height * 0.32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://scontent.fktm1-1.fna.fbcdn.net/v/t1.0-9/s960x960/61895741_1030831727110119_8215917200502947840_o.jpg?_nc_cat=102&_nc_ohc=hJzSKTrOgpUAX9-aN_s&_nc_ht=scontent.fktm1-1.fna&oh=fb4d08a533640f94828ad6f374a5a549&oe=5EC91B55"),
                      radius: 55,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      _username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        // s
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              "2",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Joined\nChallenges",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "$_tokens T",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Remaining\nTokens",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "3",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Completed\nChallenges",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 15.0),
                  ],
                ),
              ),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      child: (!_isLoading)
                          ? Column(
                              children: <Widget>[
                                Card(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 10.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Joined Challenges",
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                            Icon(Icons.navigate_next),
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Completed Challenges",
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                            Icon(Icons.navigate_next),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(child: CircularProgressIndicator()))),
            ),
          )
        : Scaffold(
            body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Loading User Profile..."),
                SizedBox(
                  width: 25.0,
                ),
                SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: Center(child: CircularProgressIndicator())),
              ],
            ),
          ));
  }
}
