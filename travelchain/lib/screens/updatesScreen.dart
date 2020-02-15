import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelchain/components/joined.dart';
import 'package:travelchain/screens/verifyVideos.dart';

class UpdatesScreen extends StatefulWidget {
  @override
  _UpdatesScreenState createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  bool verifier = false;

  Future<bool> fetchInitialPrefData() async {
    SharedPreferences verifier = await SharedPreferences.getInstance();
    return verifier.getBool("verifier");
  }

  initializeEverything() async {
   verifier = await fetchInitialPrefData();
   setState(() {
     
   });
  }

  void initState() {
    super.initState();
    initializeEverything();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
      length: verifier?4:3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Updates"),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
            tabs: verifier? [
              Tab(text: "For you"),
              Tab(text: "Messages"),
              Tab(text: "Joined"),
              Tab(text: "To Verify"),
            ]:[
              Tab(text: "For you"),
              Tab(text: "Messages"),
              Tab(text: "Joined"),
            ],
          ),
        ),
        body: verifier?TabBarView(children: [
          Center(
            child: Text("To be added"),
          ),
          Center(
            child: Text("To be added"),
          ),
          JoinedTab(),
          VerifyVideos(),
        ]):TabBarView(children: [
          Center(
            child: Text("To be added"),
          ),
          Center(
            child: Text("To be added"),
          ),
          JoinedTab(),
        ]),
      ),
    ));
  }
}
