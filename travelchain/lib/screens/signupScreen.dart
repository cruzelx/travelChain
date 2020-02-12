import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travelchain/Services/signUp.dart';
import 'package:travelchain/screens/loginScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final Widget signupImage = SvgPicture.asset(
    'assets/images/signup.svg',
    semanticsLabel: 'signuplogo',
  );
  final globalKey = GlobalKey<ScaffoldState>();
  bool _visible = false;
  bool _isVerifier = false;
  bool isFormValid = false;
  final snackbar = SnackBar(content: Text("Something went wrong :("));
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;
  TextEditingController _emailController;

  var currentLocation;

  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _emailController = TextEditingController();

    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      setState(() {
        currentLocation = value;
      });
    });
  }

  Future<dynamic> _postSignUp() async {
    var signupdata = SignUp(
        name: _usernameController.text.toString(),
        password: _passwordController.text.toString(),
        gender: "male",
        lat: currentLocation.latitude,
        long: currentLocation.longitude,
        verifier: _isVerifier);

    final res = await http.post("https://travelchain.herokuapp.com/addUser",
        body: json.encode(signupdata.toJson()),
        headers: {'Content-Type': 'application/json'}).then((value) {
      print(value);
    }).catchError((e) {
      print("Error during signup");
      isFormValid = false;
      globalKey.currentState.showSnackBar(snackbar);
    });
  }

  void _checkValidity() {
    setState(() {
      if (_usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.toString() ==
              _confirmPasswordController.text.toString() &&
          EmailValidator.validate(_emailController.text)) {
        isFormValid = true;
        _postSignUp();
      } else {
        print("error matching");
        isFormValid = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          key: globalKey,
          backgroundColor: Theme.of(context).backgroundColor,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Text("Sign Up",
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      height: 150.0,
                      child: Stack(
                        children: <Widget>[
                          signupImage,
                          Align(
                            alignment: Alignment.topLeft,
                            child: Hero(
                              tag: 'travelChainHero',
                              child: RichText(
                                text: TextSpan(
                                  text: 'travel',
                                  style: TextStyle(
                                      fontSize: 16.0, color: Color(0xff343a45)),
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
                      height: 15.0,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hasFloatingPlaceholder: true,
                          hintText: "username"),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hasFloatingPlaceholder: true,
                          hintText: "email"),
                    ),
                    SizedBox(
                      height: 15.0,
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
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.verified_user),
                        hasFloatingPlaceholder: true,
                        hintText: "confirm password",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Are you a verifier ?",
                            style: TextStyle(
                                color: (_isVerifier)
                                    ? Colors.black
                                    : Colors.black54)),
                        Checkbox(
                            value: _isVerifier,
                            onChanged: (val) {
                              setState(() {
                                _isVerifier = val;
                              });
                            })
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: RaisedButton(
                        child: Text("Sign Up"),
                        textColor: Colors.white,
                        color: Color(0xff073b94),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        onPressed: () {
                          print(_usernameController.text);
                          print(_passwordController.text);
                          print(_confirmPasswordController.text);
                          print(_emailController.text);
                          _checkValidity();
                          if (!isFormValid) {
                            print("alex");
                            globalKey.currentState.showSnackBar(snackbar);
                          } else {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => LoginScreen()));
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account? ",
                            style: TextStyle(color: Colors.black54)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            "Login",
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
      ),
    );
  }
}
