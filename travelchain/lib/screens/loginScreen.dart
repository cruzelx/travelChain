import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelchain/Services/fetchUsers.dart';
import 'package:travelchain/Services/login.dart';
import 'package:travelchain/screens/mainScreen.dart';
import 'package:travelchain/screens/signupScreen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Widget loginImage = SvgPicture.asset(
    'assets/images/loginlogo.svg',
    semanticsLabel: 'travelChain logo',
  );
  TextEditingController _usernameController;
  TextEditingController _passwordController;

  final globalKey = GlobalKey<ScaffoldState>();
  final snackbar = SnackBar(content: Text("Something went wrong :("));

  bool _visible = false;
  bool _isLoading = false;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  Future<dynamic> _postLogin() async {
    var userLogin = Login(
        name: _usernameController.text.toString(),
        password: _passwordController.text.toString());
    var res = await http
        .get(
            "https://travelchain.herokuapp.com/signIn?name=${_usernameController.text.toString()}&password=${_passwordController.text.toString()}")
        .then((value) {
      var userDetails = FetchUser.fromJson(json.decode(value.body));
      print(userDetails);
      setDataInSharedPreferences(
          userDetails.name, userDetails.uid, userDetails.verifier);
      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => MainScreen()),
      );
    }).catchError((e) {
      globalKey.currentState.showSnackBar(snackbar);
    });
  }

  _checkValidity() {
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      _postLogin();
    } else {
      globalKey.currentState.showSnackBar(snackbar);
    }
  }

  //--------------------Shared Preferences------------------------

  setDataInSharedPreferences(String name, int uid, bool verifier) async {
    SharedPreferences userData = await SharedPreferences.getInstance();
    userData.setString("name", name);
    userData.setInt("uid", uid);
    userData.setBool("verifier", verifier);
  }

  //--------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          key: globalKey,
          backgroundColor: Theme.of(context).backgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Sign In",
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: 170.0,
                        child: Stack(
                          children: <Widget>[
                            loginImage,
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Hero(
                                tag: 'travelChainHero',
                                child: RichText(
                                  text: TextSpan(
                                    text: 'travel',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xff343a45)),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Chain',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff073b94),
                                              fontSize: 20.0))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hasFloatingPlaceholder: true,
                            hintText: "username"),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hasFloatingPlaceholder: true,
                          hintText: "password",
                          suffixIcon: IconButton(
                            icon: (_visible)
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _visible = !_visible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_visible,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Align(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(0xff073b94),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.centerRight,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: RaisedButton(
                          child: (_isLoading)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                      Text("Logging In"),
                                      SizedBox(
                                          height: 15.0,
                                          width: 15.0,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator())),
                                    ])
                              : Text("Login"),
                          textColor: Colors.white,
                          color: Color(0xff073b94),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          onPressed: () {
                            _checkValidity();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account? ",
                          style: TextStyle(color: Colors.black54)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => SignupScreen()));
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff073b94)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
