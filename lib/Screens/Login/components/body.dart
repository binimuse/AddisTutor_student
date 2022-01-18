import 'dart:convert';

import 'package:addistutor_student/Screens/Profile/profile.dart';
import 'package:addistutor_student/components/text_field_container.dart';
import 'package:addistutor_student/remote_services/api.dart';
import 'package:flutter/material.dart';
import 'package:addistutor_student/Screens/Login/components/background.dart';
import 'package:addistutor_student/Screens/Signup/signup_screen.dart';
import 'package:addistutor_student/Screens/main/main.dart';
import 'package:addistutor_student/components/already_have_an_account_acheck.dart';

import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  Body({
    Key? key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Body> {
  bool isLoading = false;
  SharedPreferences? localStorage;
  final _formKey = GlobalKey<FormState>();
  GlobalKey<_LoginScreenState> _myKey = GlobalKey();
  var body;
  // ignore: prefer_typing_uninitialized_variables
  var email;
  // ignore: prefer_typing_uninitialized_variables
  var password;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                    fontSize: 23),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/login.svg",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              TextFieldContainer(
                child: TextFormField(
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    hintText: "Email",
                    icon: Icon(
                      Icons.email,
                      color: kPrimaryColor,
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (emailval) {
                    if (emailval!.isEmpty) {
                      return "Please put your email";
                    }
                    email = emailval.toString();
                    return null;
                  },
                  // validator: (value) {
                  //   return signupController.validatephone(value!);
                  // },
                ),
              ),
              TextFieldContainer(
                child: TextFormField(
                  obscureText: true,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    hintText: "Password",
                    icon: Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                    suffixIcon: Icon(
                      Icons.visibility,
                      color: kPrimaryColor,
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (passwordval) {
                    if (passwordval!.isEmpty) {
                      return "Please put your Password";
                    }
                    password = passwordval.toString();
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                // ignore: deprecated_member_use
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36),
                  ),
                  color: kPrimaryColor,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: isLoading == false
                        ? const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox(
                            height: 20,
                            width: 20,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      isLoading = true;
    });
    var data = {'email': email, 'password': password};
    var res = await Network().authData(data, "login-student");
    body = json.decode(res.body);
    bool isupdated;
    // ignore: avoid_print

    //  print(body.toString());
    if (res.statusCode == 200) {
      // commit();
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString("token", body["token"]);

      localStorage.setString('user', json.encode(body['user']));

      var token = localStorage.getString('user');
      var bodys = json.decode(token!);

      if (bodys["student_id"] == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Main(),
          ),
        );
      }
      // if (isupdated!) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => Main(),
      //     ),
      //   );
      // } else {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ProfileScreen(),
      //     ),
      //   );
      // }

      isLoading = false;
    } else if (res.statusCode == 401) {
      showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: const Text('info'),
          content: new Text(body["message"]),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                setState(() {
                  isLoading = false;
                });
              },
              child: new Text('ok'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: const Text('info'),
          content: new Text(body["message"]),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                setState(() {
                  isLoading = false;
                });
              },
              child: new Text('ok'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> closeDialog(bool stat, var data) async {
    await Future.delayed(const Duration(seconds: 1));
    // Dismiss CircularProgressIndicator
    // Navigator.of(Get.context!).pop();
    if (stat == false) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          elevation: 0,
          backgroundColor: Color(0xffffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: 15),
            const Text(
              'Error',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Divider(
              height: 1,
              color: kPrimaryColor,
            ),
          ]),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: 15),
            const Text(
              'incorrect Email or Password',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
          ]),
          actions: <Widget>[
            // ignore: deprecated_member_use
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: InkWell(
                highlightColor: Colors.grey[200],
                onTap: () {
                  Navigator.of(context).pop(true);
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Center(
                  child: Text(
                    "Ok",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
