import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travelchain/screens/createChallengeScreen.dart';

class SetLocationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context)=>CreateChallengeScreen())
          );
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
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 6.0)],
            ),
          ),
        ),
      ),
    );
  }
}
