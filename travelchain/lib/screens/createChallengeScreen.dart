import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:travelchain/Services/createChallenge.dart';
import 'package:travelchain/screens/mainScreen.dart';
import 'package:http/http.dart' as http;

class CreateChallengeScreen extends StatefulWidget {
  final Loc loc;
  CreateChallengeScreen({this.loc});

  @override
  _CreateChallengeScreenState createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _prizeController = TextEditingController();
  bool isSaved = false;

  Future<dynamic> _postChallenge() async {
    var challenge = CreateChallenge(
      creatoruid: widget.loc.creatorid.toInt(),
      name: _titleController.text.toString(),
      description: _descriptionController.text.toString(),
      prize: double.parse(_prizeController.text.toString()),
      long: widget.loc.longitude.toDouble(),
      lat: widget.loc.latitude.toDouble(),
    );

    final res = await http
        .post("https://travelchain.herokuapp.com/createChallenge",
            headers: {'Content-Type': 'application/json'},
            body: json.encode(challenge.toJson()))
        .then((onVal) {
      print("uploaded");
      print(json.encode(challenge.toJson()));
    }).catchError((e) {
      print("error uploading");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            setState(() {
              if (_titleController.text.isNotEmpty &&
                  _prizeController.text.isNotEmpty &&
                  _descriptionController.text.isNotEmpty &&
                  isSaved == false) {
                _postChallenge();
                isSaved = true;
              }
            });
          },
          label: (!isSaved)
              ? Text("Save")
              : Row(
                  children: <Widget>[
                    Text("Saved"),
                    Icon(Icons.check),
                  ],
                )),
      appBar: AppBar(
        title: Text("Create Challenge"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                    icon: Icon(Icons.title),
                    hintText: "Enter Title",
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Color(0xffededed),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color(0xffededed),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                      borderSide: BorderSide(
                        color: Color(0xffededed),
                      ),
                    )),
              ),
              SizedBox(height: 15.0),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  icon: Icon(Icons.book),
                  hintText: "Enter Description",
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Color(0xffededed),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xffededed),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xffededed),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: _prizeController,
                decoration: InputDecoration(
                  icon: Icon(Icons.monetization_on),
                  hintText: "Enter Prize",
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Color(0xffededed),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xffededed),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xffededed),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
