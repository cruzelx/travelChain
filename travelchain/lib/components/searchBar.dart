import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:travelchain/screens/userProfile.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _searchController;
  String _searchAddr;
  
  _searchLocations(){
    
  }
  @override
  Widget build(BuildContext context) {
    return Positioned(
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
                    padding: EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder:(context)=>UserProfile(),
                          ),
                        );
                      },
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
    );
  }
}
