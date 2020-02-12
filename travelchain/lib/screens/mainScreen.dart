import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelchain/Services/fetchDescription.dart';
import 'package:travelchain/Services/fetchUsers.dart';
import 'package:travelchain/components/mapPin.dart';
import 'package:travelchain/components/searchBar.dart';
import 'package:travelchain/components/setLocationButton.dart';
import 'package:travelchain/screens/createChallengeScreen.dart';
import 'package:travelchain/screens/updatesScreen.dart';
import '../components/challengeDescription.dart';
import '../Services/fetchAllChallenges.dart';

class Loc {
  final double latitude;
  final double longitude;
  final int creatorid;
  const Loc({this.longitude, this.latitude, this.creatorid});
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController _searchController;
  GoogleMapController mapController;
  String _searchAddr;
  bool _fabTap = false;
  var currentLocation;
  bool mapToggle = false;

  List<IconData> _chipIcons = [
    Icons.restaurant,
    Icons.local_drink,
    Icons.local_movies,
    Icons.local_grocery_store,
  ];

  List<String> _chipValue = ["Restaurant", "Pub", "Movie", "Grocery Store"];
  bool _chipVisibility = false;
  bool _fabVisibility = true;
  bool _createChallengeVisibility = false;
  bool _setMapVisibility = false;
  int _selectedIndex = 0;
  double centerLongitude;
  double centerLatitude;
  bool _isJoined = false;

  final globalKey = GlobalKey<ScaffoldState>();
  final snackBar = SnackBar(content: Text("Error Joining Challenge :("));

  BitmapDescriptor flagIcon;

  Set<Marker> markerSet = new Set();

  int sUid;

  Future<dynamic> joinChallenge(int cid) async {
    final res = await http
        .get(
            "https://travelchain.herokuapp.com/joinChallenge?uid=$sUid&cid=$cid")
        .then((value){
          setState(() {
            _isJoined = true;
          });
        }) 
        .catchError((e) {
      globalKey.currentState.showSnackBar(snackBar);
      print("Error Joining");
    });
  }

  Future<GetAllChallenges> getAllChallenges() async {
    final res =
        await http.get("http://travelchain.herokuapp.com/getChallenges");
    if (res.statusCode == 200) {
      final int len = json.decode(res.body).length;
      // var challenge = GetAllChallenges.fromJson(json.decode(res.body)[0]);
      // print(challenge.name);

      for (int i = 0; i < len; i++) {
        var challenge = GetAllChallenges.fromJson(json.decode(res.body)[i]);
        markerSet.add(Marker(
          markerId: MarkerId("${challenge.cid}_${challenge.name}_marker"),
          position: LatLng(
              challenge.loc.coordinates[1], challenge.loc.coordinates[0]),
          infoWindow: InfoWindow(
              title: "${challenge.name}",
              onTap: () {
                showBottomSheetDescription(context, challenge.cid);
              }),
          icon: flagIcon,
        ));
      }
    } else {
      throw Exception("Failed to fetch data...");
    }
  }

  Future<FetchDescription> fetchDescription(int cid) async {
    final res =
        await http.get("https://travelchain.herokuapp.com/challenge?cid=$cid");
    if (res.statusCode == 200) {
      print("Incoming: ");
      print(res.body);
      return FetchDescription.fromJson(json.decode(res.body));
    } else {
      print(Exception("Error Fetching Description for challenge id $cid"));
    }
  }

  Future<FetchUser> fetchUser(int uid) async {
    final res =
        await http.get("https://travelchain.herokuapp.com/getUser?uid=$uid");
    if (res.statusCode == 200) {
      print(res.body);
      return FetchUser.fromJson(json.decode(res.body));
    } else {
      print(Exception("Error Fetching User $uid data"));
    }
  }

  Future<int> getUidFromSharedPreferences() async {
    SharedPreferences userData = await SharedPreferences.getInstance();
    int uid = userData.getInt("uid");
    return uid;
  }

  showBottomSheetDescription(BuildContext context, int cid) {
    fetchDescription(cid).then((description) {
      fetchUser(description.creatoruid).then((userInfo) {
        print(description.description);
        bottomModalSheet(
            context,
            description.name,
            description.tokenprice,
            description.description,
            description.startdate,
            description.enddate,
            userInfo.name,
            description.creatoruid,
            cid);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    surukoFunction();
  }

  void surukoFunction() async {
    sUid = await getUidFromSharedPreferences();
    print("aayo hai aayo uid");
    print(sUid);
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(30, 30)), 'assets/images/flag3.png')
        .then((onValue) => flagIcon = onValue);
    getAllChallenges();
    _searchController = TextEditingController();

    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((currLoc) {
      setState(() {
        currentLocation = currLoc;
        mapToggle = true;
        // markerSet.add(Marker(
        //   markerId: MarkerId("marker_id_1"),
        //   position: LatLng(currentLocation.latitude, currentLocation.longitude),
        //   infoWindow: InfoWindow(
        //       title: "Trekking",
        //       snippet: "Walkathon to Poon Hill",
        //       onTap: () {
        //         ChallengeDescription.bottomModalSheet(context);
        //       }),
        //   icon: BitmapDescriptor.defaultMarker,
        // ));
      });
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  _searchLocations() {
    Geolocator().placemarkFromAddress(_searchAddr).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 15.0,
        ),
      ));
      // if (result.length != 0) {
      //   markerSet.add(Marker(
      //       markerId: MarkerId("${result[0].name}"),
      //       position: LatLng(
      //           result[0].position.latitude, result[0].position.longitude),
      //       infoWindow: InfoWindow(
      //           title: "${result[0].locality}",
      //           snippet: "Lets travel",
      //           onTap: () {}),
      //       onTap: () {}));
      // }
    });
  }

  _navigateToUpdatesScreen(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (BuildContext context) => UpdatesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: globalKey,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 12.0,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
              if (index == 1) {
                _chipVisibility = true;
              } else {
                _chipVisibility = false;
              }
            });
            if (index == 3) {
              _navigateToUpdatesScreen(context);
            }
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.trending_up), title: Text("Trending")),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                title: Text("Redeem")),
            BottomNavigationBarItem(
                icon: Icon(Icons.security), title: Text("Private")),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), title: Text("Updates")),
          ],
        ),
        floatingActionButton: Padding(
          padding: (!_chipVisibility)
              ? EdgeInsets.all(0.0)
              : EdgeInsets.only(bottom: 35.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: (_fabVisibility)
                ? SpeedDial(
                    elevation: 10.0,
                    overlayOpacity: 0.0,
                    curve: Curves.easeInOut,
                    visible: true,
                    backgroundColor: Colors.white,
                    closeManually: false,
                    animatedIcon: AnimatedIcons.menu_close,
                    foregroundColor: Colors.black,
                    onOpen: () {
                      setState(() {
                        _fabTap = true;
                      });
                    },
                    onClose: () {
                      setState(() {
                        _fabTap = false;
                      });
                    },
                    children: [
                      SpeedDialChild(
                        child: Icon(Icons.add),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        onTap: () {
                          print("add");
                          setState(() {
                            _fabVisibility = false;
                            _setMapVisibility = true;
                            _createChallengeVisibility = false;
                          });
                        },
                      ),
                      SpeedDialChild(
                        child: Icon(Icons.location_searching),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        onTap: () {
                          print("locate");
                        },
                      ),
                      SpeedDialChild(
                        child: Icon(Icons.refresh),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        onTap: () {
                          getAllChallenges();
                          print("refresh");
                        },
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // color: Colors.pinkAccent,
              child: mapToggle
                  ? GoogleMap(
                      onMapCreated: onMapCreated,
                      onCameraMove: (CameraPosition x) {
                        print(x.target.latitude);
                        setState(() {
                          centerLatitude = x.target.latitude;
                          centerLongitude = x.target.longitude;
                        });
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(currentLocation.latitude,
                            currentLocation.longitude),
                        zoom: 15.0,
                      ),
                      markers: markerSet,
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
            SearchBar(),
            (!_fabVisibility) ? mapPin : Container(),
            (_setMapVisibility)
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _fabVisibility = true;
                          _setMapVisibility = false;
                        });
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => CreateChallengeScreen(
                                        loc: Loc(
                                      longitude: centerLongitude,
                                      latitude: centerLatitude,
                                      creatorid: sUid,
                                    ))));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 30.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Set Location"),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(color: Colors.grey, blurRadius: 6.0)
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 50.0,
                  child: (_chipVisibility)
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _chipValue.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: <Widget>[
                                Chip(
                                  backgroundColor: Colors.white,
                                  elevation: 5.0,
                                  avatar: Icon(_chipIcons[index],
                                      color: Colors.black54, size: 15.0),
                                  label: Text("${_chipValue[index]}"),
                                ),
                                SizedBox(
                                  width: 5.0,
                                )
                              ],
                            );
                          })
                      : Container()),
            ),
          ],
        ),
      ),
    );
  }

  void bottomModalSheet(context, String name, int tokenprice, String descript,
      String startDate, String endDate, String creatorName, int uid, int cid) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return Container(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: 3.0,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://scontent.fktm1-1.fna.fbcdn.net/v/t1.0-9/s960x960/61895741_1030831727110119_8215917200502947840_o.jpg?_nc_cat=102&_nc_ohc=hJzSKTrOgpUAX9-aN_s&_nc_ht=scontent.fktm1-1.fna&oh=fb4d08a533640f94828ad6f374a5a549&oe=5EC91B55"),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(name),
                          Row(
                            children: <Widget>[
                              Text("$tokenprice T",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
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
                              Text(creatorName),
                              Text(
                                  "${DateFormat('MMMM d, y - kk:mm').format(DateTime.now())}"),
                            ],
                          ),
                          (sUid != uid)
                              ? RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  onPressed: () {
                                    if (!_isJoined) {
                                      joinChallenge(cid);
                                    }
                                    
                                  },
                                  color: (_isJoined)
                                      ? Colors.grey
                                      : Theme.of(context).primaryColor,
                                  child: (_isJoined)
                                      ? Text(
                                          "Joined",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(
                                          "+Join",
                                          style: TextStyle(color: Colors.white),
                                        ))
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(descript),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
