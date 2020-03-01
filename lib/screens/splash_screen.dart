import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:link/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void toOnboardingScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username == null) {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Onboarding()));
    } else {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 10), toOnboardingScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
      Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            "assets/images/image1.jpg",
            fit: BoxFit.fitHeight,
          )),
      Column(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Text("Product Locator",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                        ))
                  ]))),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitCircle(color: Colors.white),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Text("Every Product Within Your Reach",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700))
                ],
              ))
        ],
      )
    ]));
  }
}
