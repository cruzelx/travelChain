import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:travelchain/screens/updatesScreen.dart';

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
  double _centerLongitude;
  double _centerLatitude;

  Set<Marker> markerSet = new Set();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((currLoc) {
      setState(() {
        currentLocation = currLoc;
        mapToggle = true;
        markerSet.add(Marker(
          markerId: MarkerId("marker_id_1"),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(
              title: "Trekking",
              snippet: "Walkathon to Poon Hill",
              onTap: () {
                _bottomModalSheet(context);
              }),
          icon: BitmapDescriptor.defaultMarker,
        ));
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
      if (result.length != 0) {
        markerSet.add(Marker(
            markerId: MarkerId("${result[0].name}"),
            position: LatLng(
                result[0].position.latitude, result[0].position.longitude),
            infoWindow: InfoWindow(
                title: "${result[0].locality}",
                snippet: "Lets travel",
                onTap: () {}),
            onTap: () {}));
      }
    });
  }

  void _bottomModalSheet(context) {
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
                          Text("Walkathon"),
                          Row(
                            children: <Widget>[
                              Icon(Icons.attach_money),
                              Text("20T",
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
                              Text("Alex Bhattarai"),
                              Text(
                                  "${DateFormat('MMMM d, y - kk:mm').format(DateTime.now())}"),
                            ],
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            onPressed: () {},
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              "+Join",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
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
                            Text("Around Swayambhu Periphery"),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            if (index == 3){
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (BuildContext context)=>UpdatesScreen()
                ),
              );
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
          padding: const EdgeInsets.only(bottom: 35.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: (_fabVisibility)
                ? SpeedDial(
                    elevation: 10.0,
                    overlayOpacity: 0.0,
                    curve: Curves.easeInOut,
                    visible: true,
                    backgroundColor: _fabTap
                        ? Colors.pinkAccent
                        : Theme.of(context).primaryColor,
                    closeManually: false,
                    animatedIcon: AnimatedIcons.menu_close,
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
                        onTap: () {
                          print("add");
                          setState(() {
                            _fabVisibility = false;
                            _setMapVisibility = true;
                            _createChallengeVisibility = false;
                          });
                        },
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      SpeedDialChild(
                        child: Icon(Icons.location_searching),
                        onTap: () {
                          print("locate");
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
                          _centerLatitude = x.target.latitude;
                          _centerLongitude = x.target.longitude;
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
            Positioned(
              top: 10.0,
              right: 20.0,
              left: 20.0,
              child: Container(
                height: 47.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10.0,
                      )
                    ]),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _searchController,
                  onTap: () {},
                  onChanged: (val) {
                    setState(() {
                      _searchAddr = val;
                    });
                  },
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.menu),
                    ),
                    suffixIcon: SizedBox(
                      height: double.infinity,
                      width: 96.0,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: _searchLocations,
                            icon: Icon(Icons.search),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 8.0, top: 8.0, bottom: 8.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: CircleAvatar(
                                child: Text("A"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    border: InputBorder.none,
                    hintText: 'Search Challenges',
                  ),
                ),
              ),
            ),
            (!_fabVisibility)
                ? Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/mapPin.png', scale: 2),
                  )
                : Container(),
            (_setMapVisibility)
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _createChallengeVisibility = true;
                          _setMapVisibility = false;
                        });
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
            (_createChallengeVisibility)
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 15.0)
                          ],
                        ),
                        width: double.infinity,
                        height: 345.0,
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Text(
                                  "Create Challenge",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.black87),
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.title),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 8.0),
                                          filled: true,
                                          fillColor: Color(0xfff5f5f5),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xfff5f5f5)),
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xfff5f5f5)),
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),

                                          // prefixIcon: Icon(Icons.title),
                                          hasFloatingPlaceholder: true,
                                          hintText: "Enter Title"),
                                    ),
                                    SizedBox(height: 10.0),
                                    TextFormField(
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.description),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 8.0),
                                        filled: true,
                                        fillColor: Color(0xfff5f5f5),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xfff5f5f5)),
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xfff5f5f5)),
                                            borderRadius:
                                                BorderRadius.circular(15.0)),

                                        //prefixIcon: Icon(Icons.description),
                                        hasFloatingPlaceholder: true,
                                        hintText: "Enter Description",
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.monetization_on),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 8.0),
                                        filled: true,
                                        fillColor: Color(0xfff5f5f5),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xfff5f5f5)),
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xfff5f5f5)),
                                            borderRadius:
                                                BorderRadius.circular(15.0)),

                                        //prefixIcon: Icon(Icons.description),
                                        hasFloatingPlaceholder: true,
                                        hintText: "Enter Token Price",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          _fabVisibility = true;
                                          _createChallengeVisibility = false;
                                          _setMapVisibility = false;
                                          markerSet.add(Marker(
                                            markerId: MarkerId("id_${_centerLongitude}"),
                                            position: LatLng(_centerLatitude, _centerLongitude),
                                            infoWindow: InfoWindow(
                                              title:"Walkathon",
                                              snippet: "Around Swayambhu Periphery",
                                              onTap: (){
                                                _bottomModalSheet(context);
                                              }
                                            ),
                                          ));
                                        });
                                      },
                                      color: Theme.of(context).primaryColor,
                                      child: Text("Create",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
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
}
