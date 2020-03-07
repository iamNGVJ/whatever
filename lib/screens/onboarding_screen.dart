import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:link/screens/auth/register_screen.dart';
import 'auth/signin_screen.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'VarelaRound'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/image1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      color: Colors.black.withOpacity(0),
                    ),
                  ),
                ),
                Container(
                  width:
                      ScreenUtil().setWidth(MediaQuery.of(context).size.width),
                  height: ScreenUtil()
                      .setHeight(MediaQuery.of(context).size.height),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: ScreenUtil()
                            .setHeight(MediaQuery.of(context).size.width / 2),
                      ),
                      Text(
                        "Product Locator",
                        style: TextStyle(
                            fontSize: ScreenUtil()
                                .setSp(28.0, allowFontScalingSelf: true),
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: ScreenUtil()
                            .setHeight(MediaQuery.of(context).size.width / 2),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: ScreenUtil().setHeight(50),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Colors.white),
                                  bottom: BorderSide(color: Colors.white),
                                  left: BorderSide(color: Colors.white),
                                  right: BorderSide(color: Colors.white))),
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(15, allowFontScalingSelf: true),
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterAccount()));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: ScreenUtil().setHeight(50),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Colors.white),
                                  bottom: BorderSide(color: Colors.white),
                                  left: BorderSide(color: Colors.white),
                                  right: BorderSide(color: Colors.white))),
                          child: Text("Register",
                              style: TextStyle(
                                  fontSize: ScreenUtil()
                                      .setSp(15, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Text(
                    "hit200-v1.00",
                    style: TextStyle(
                      fontSize:
                          ScreenUtil().setSp(10, allowFontScalingSelf: true),
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
