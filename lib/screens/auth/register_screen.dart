import "dart:async";
import "dart:convert";
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:link/models/user.dart";
import "package:link/screens/auth/signin_screen.dart";
import "package:progress_dialog/progress_dialog.dart";
import "package:http/http.dart" as http;

class RegisterAccount extends StatefulWidget {
  @override
  _RegisterAccountState createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  final _formKey = GlobalKey<FormState>();
  String username;
  String email;
  String password;
  String mobileNumber;

  // ignore: missing_return
  Future<User> _register(
      ProgressDialog pr, username, email, mobileNumber, password) async {
    const url = "http://hitwo-api.herokuapp.com/signup";
    var response = await http.post(url, body: {
      "username": username,
      "email": email,
      "mobileNumber": mobileNumber,
      "password": password
    });

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      pr.update(
        message: "User exists. Please login",
        progressWidget: SpinKitCircle(
          color: Colors.redAccent,
        ),
        messageTextStyle: TextStyle(
          color: Colors.red,
          fontSize: ScreenUtil().setSp(19.0, allowFontScalingSelf: true),
          fontWeight: FontWeight.w600,
        ),
      );
      Timer(Duration(seconds: 3), () {
        pr.hide().then((isHidden) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignIn()),
          );
        });
      });
    } else {
      pr.update(
        message: "Server error. Try changing username.",
        progressWidget: SpinKitCircle(
          color: Colors.redAccent,
        ),
        messageTextStyle: TextStyle(
          color: Colors.red,
          fontSize: ScreenUtil().setSp(19.0, allowFontScalingSelf: true),
          fontWeight: FontWeight.w600,
        ),
      );
      Timer(Duration(seconds: 3), () {
        pr.hide();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "VarelaRound",
        ),
        home: Scaffold(
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SafeArea(
                    child: Column(children: <Widget>[
                  SizedBox(height: ScreenUtil().setHeight(50)),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Proceed with your",
                              style: TextStyle(
                                  fontSize: ScreenUtil()
                                      .setSp(30, allowFontScalingSelf: true),
                                  color: Colors.grey),
                            ),
                            Text(
                              "Registration",
                              style: TextStyle(
                                  fontSize: ScreenUtil()
                                      .setSp(35, allowFontScalingSelf: true),
                                  fontWeight: FontWeight.bold),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: ScreenUtil().setHeight(50)),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          labelText: "Username",
                                          hintText: "e.g. iamngoni",
                                          border: OutlineInputBorder(
                                              gapPadding: 3.5)),
                                      // ignore: missing_return
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Username format is not correct";
                                        } else {
                                          setState(() {
                                            this.username = value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          labelText: "Email",
                                          hintText:
                                              "e.g. iamngoni@product.locator",
                                          border: OutlineInputBorder(
                                              gapPadding: 3.5)),
                                      // ignore: missing_return
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Email Address format is not correct";
                                        } else {
                                          setState(() {
                                            this.email = value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          labelText: "Mobile Number",
                                          hintText: "e.g. 0777 111 111",
                                          border: OutlineInputBorder(
                                              gapPadding: 3.5)),
                                      // ignore: missing_return
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Mobile number format is not correct";
                                        } else {
                                          setState(() {
                                            this.mobileNumber = value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          labelText: "Password",
                                          hintText: "e.g. myp@55w0rd",
                                          border: OutlineInputBorder(
                                              gapPadding: 3.5)),
                                      // ignore: missing_return
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Password format is not correct";
                                        } else {
                                          setState(() {
                                            this.password = value;
                                          });
                                        }
                                      },
                                      obscureText: true,
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(30)),
                                  MaterialButton(
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: ScreenUtil().setHeight(50),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF6C00E9),
                                        ),
                                        child: Text(
                                          "Register",
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(20,
                                                  allowFontScalingSelf: true),
                                              color: Colors.white),
                                        )),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        pr = new ProgressDialog(context,
                                            type: ProgressDialogType.Normal,
                                            isDismissible: true,
                                            showLogs: false);
                                        pr.style(
                                          message: "Creating Account",
                                          borderRadius: 10.0,
                                          backgroundColor: Colors.white,
                                          progressWidget: SpinKitCircle(
                                            color: Color(0xFF6C00E9),
                                          ),
                                          elevation: 10.0,
                                          insetAnimCurve: Curves.easeInOut,
                                          messageTextStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: ScreenUtil().setSp(19.0,
                                                allowFontScalingSelf: true),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                        pr.show();
                                        var user = await _register(
                                            pr,
                                            this.username,
                                            this.email,
                                            this.mobileNumber,
                                            this.password);
                                        if (user.username != null) {
                                          pr.update(
                                            message:
                                                "Account created. User can now log in.",
                                            progressWidget: SpinKitCircle(
                                              color: Colors.greenAccent,
                                            ),
                                            messageTextStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: ScreenUtil().setSp(19.0,
                                                  allowFontScalingSelf: true),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          );
                                          Timer(Duration(seconds: 2), () {
                                            pr.hide().then((isHidden) {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SignIn()),
                                              );
                                            });
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            )
                          ]))
                ])))));
  }
}
