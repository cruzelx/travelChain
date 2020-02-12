import 'package:flutter/material.dart';
import 'package:travelchain/screens/loginScreen.dart';
import 'package:travelchain/screens/signupScreen.dart';

void main() => runApp(TravelChain());

class TravelChain extends StatefulWidget {
  @override
  _TravelChainState createState() => _TravelChainState();
}

class _TravelChainState extends State<TravelChain> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TravelChainMainPage(),
      theme: ThemeData(
          backgroundColor: Color(0xfffffff5), primaryColor: Color(0xff073b94)),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TravelChainMainPage extends StatefulWidget {
  @override
  _TravelChainMainPageState createState() => _TravelChainMainPageState();
}

class _TravelChainMainPageState extends State<TravelChainMainPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
