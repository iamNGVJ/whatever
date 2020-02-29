import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:link/models/user.dart';
import 'package:link/screens/all/home_screen.dart';
import 'package:link/screens/auth/register_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();
  String username;
  String password;

  // ignore: missing_return
  Future<User> _login(ProgressDialog pr, username, password) async{
    const url = 'http://hitwo-api.herokuapp.com/signin';
    var response = await http.post(url, body: {
      'username':username,
      'password': password
    });

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    }else if(response.statusCode == 401){
      pr.update(
          message: 'Error: Account not found'
      );
      Timer(Duration(seconds: 3), (){
        pr.hide().then((isHidden){
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterAccount()));
        });
      });
    }else{
      pr.update(
          message: '${response.statusCode}: Server error'
      );
      Timer(Duration(seconds: 3), (){
        pr.hide();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    ProgressDialog pr;
    return MaterialApp(
        theme: ThemeData(fontFamily: 'VarelaRound'),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 120
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Proceed with your",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.grey
                          ),
                        ),
                        Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 50
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0
                                ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Username",
                                    hintText: "e.g. iamngoni",
                                    border: OutlineInputBorder(
                                      gapPadding: 3.5
                                    )
                                  ),
                                  // ignore: missing_return
                                  validator: (value){
                                    if(value.isEmpty){
                                      return "Username format is not correct";
                                    }else{
                                      setState(() {
                                        this.username = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 8.0
                                ),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Password",
                                      hintText: "e.g. myp@55w0rd",
                                      border: OutlineInputBorder(
                                          gapPadding: 3.5
                                      )
                                  ),
                                  // ignore: missing_return
                                  validator: (value){
                                    if(value.isEmpty){
                                      return "Password format is not correct";
                                    }else{
                                      setState(() {
                                        this.password = value;
                                      });
                                    }
                                  },
                                  obscureText: true,
                                ),
                              ),
                              SizedBox(
                                height: 30
                              ),
                              MaterialButton(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF6C00E9),
                                  ),
                                  height: 50,
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white
                                      ),
                                    )
                                ),
                                onPressed: () async {
                                  final prefs = await SharedPreferences.getInstance();
                                  if(_formKey.currentState.validate()){
                                    pr = new ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
                                    pr.style(
                                      message: 'Signing in...',
                                      borderRadius: 10.0,
                                      backgroundColor: Colors.white,
                                      progressWidget: SpinKitCircle(color: Color(0xFF6C00E9)),
                                      elevation: 24.0,
                                      insetAnimCurve: Curves.easeInOut,
                                      messageTextStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.w600
                                      )
                                    );
                                    pr.show();
                                    var user = await _login(pr, this.username, this.password);
                                    if(user.username != null){
                                      await prefs.setString('username', user.username);
                                      await prefs.setString('email', user.email);
                                      await prefs.setString('mobileNumber', user.mobileNumber);
                                      await prefs.setBool('isVerified', user.isVerified);
                                      pr.update(
                                        message: 'Authentication Successful',
                                        progressWidget: SpinKitCircle(color: Colors.greenAccent),
                                        messageTextStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w600
                                        )
                                      );
                                      Timer(Duration(seconds: 2), (){
                                        pr.hide().then((isHidden){
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                                        });
                                      });
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ]
              ),
            ),
          ),
      )
    );
  }
}
