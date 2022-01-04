import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notebook/auth/auth_service/auth_service.dart';
import 'package:notebook/paints/backgrounds.dart';
import 'package:notebook/shared/providers.dart';
import 'package:notebook/wrapper.dart';

// ignore: must_be_immutable
class Register extends StatefulWidget {
  bool signIn;
  Register({this.signIn});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  File _image;
  final picker = ImagePicker();
  bool lse = false;

  @override
  Widget build(BuildContext context) {
    if (widget.signIn == true) {
      lse = true;
    }
    final _inputDecoration = InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey[200], width: 2),
            borderRadius: BorderRadius.circular(7.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan, width: 2.5),
            borderRadius: BorderRadius.circular(7.0)),
        labelStyle: TextStyle(color: Colors.cyan[800]));
    Authentications auth = Authentications();
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController pass = TextEditingController();
    return CustomPaint(
      painter: LPG(),
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0),
        child: Column(children: [
          Center(
              child: Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(.5),
                child: _image == null
                    ? Icon(Icons.person, size: 40.0, color: Colors.cyan)
                    : null,
                backgroundImage: _image == null ? null : FileImage(_image),
                radius: 70.0,
              ),
              Positioned(
                child: IconButton(
                    onPressed: () async {
                      final pickedFile =
                          await picker.getImage(source: ImageSource.gallery);
                      setState(() {
                        if (pickedFile != null) {
                          _image = File(pickedFile.path);
                        }
                      });
                    },
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      size: 40.0,
                      color: Colors.blueGrey,
                    )),
                top: 90.0,
                left: 90.0,
              )
            ],
          )),
          Divider(height: 40.0),
          Expanded(
            child: ListView(
              children: [
                AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  height: lse ? 0.0 : MediaQuery.of(context).size.height * .09,
                  duration: Duration(milliseconds: 500),
                  child: TextFormField(
                    style: TextStyle(color: Colors.cyan[800]),
                    cursorColor: Colors.cyan,
                    controller: name,
                    decoration: _inputDecoration.copyWith(
                        labelText: "Name",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide: BorderSide(
                                width: 2,
                                color: !lse
                                    ? Colors.blueGrey[200]
                                    : Colors.transparent))),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  style: TextStyle(color: Colors.cyan[800]),
                  cursorColor: Colors.cyan,
                  controller: email,
                  decoration: _inputDecoration.copyWith(labelText: "Email"),
                ),
                SizedBox(height: 10),
                TextFormField(
                  style: TextStyle(color: Colors.cyan[800]),
                  cursorColor: Colors.cyan,
                  controller: pass,
                  decoration: _inputDecoration.copyWith(labelText: "Password"),
                ),
                SizedBox(height: 10),
                Center(
                  child: Consumer(builder: (BuildContext context,
                      T Function<T>(ProviderBase<Object, T>) see,
                      Widget child) {
                    final a = see(aimProvider).state;
                    final b = see(boardProvider).state;
                    final s = see(standardProvider).state;

                    return GestureDetector(
                        onTap: () async {
                          if (lse) {
                            dynamic result =
                                await auth.signIn(email.text, pass.text);
                            if (result != "Welcome Back!") {
                              final snackBar =
                                  SnackBar(content: Text("$result"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Wrapper()));
                            }
                          } else {
                            if (name.text.isNotEmpty &&
                                email.text.isNotEmpty &&
                                pass.text.length >= 6) {
                              dynamic result = await auth.registerUser(
                                  name.text, email.text, pass.text, a, s, b);

                              if (result != "Registered") {
                                final snackBar =
                                    SnackBar(content: Text("$result"));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Wrapper()));
                              }
                            }
                            if (name.text.isEmpty) {
                              final snackBar = SnackBar(
                                  content: Text("Name field cannot be empty"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            if (email.text.isEmpty) {
                              final snackBar = SnackBar(
                                  content: Text("Email cannot be empty"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            if (pass.text.length < 6) {
                              final snackBar = SnackBar(
                                  content: Text("Password is too weak"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }

                          return CircularProgressIndicator(color: Colors.cyan);
                        },
                        child: Text(
                          lse ? "Login" : "Register",
                          style: TextStyle(
                              color: Colors.cyan[800],
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600),
                        ));
                  }),
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(flex: 1, child: Divider()),
                    Text("OR",
                        style: TextStyle(
                            color: Colors.cyan[800],
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600)),
                    Flexible(flex: 1, child: Divider()),
                  ],
                ),
                SizedBox(height: 5.0),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    lse ? "Login using" : "Register using",
                    style: TextStyle(
                        color: Colors.cyan[800],
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600),
                  ),
                )),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // dynamic result = auth.signInWithGoogle();

                          // if (result.runtimeType == Future) {
                          //   Navigator.pushReplacement(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => Wrapper()));
                          // }
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset("assets/google_logo.png",
                                  height: 25.0, width: 25.0),
                              Text(
                                "Google",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: GestureDetector(
                        // onTap: () => auth.signInWithFacebook(),
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.blue[900]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset("assets/facebook_logo.png",
                                  height: 25.0, width: 25.0),
                              Text(
                                "Facebook",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 11.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.0),
                TextButton(
                    onPressed: () {
                      setState(() {
                        lse = !lse;
                      });
                    },
                    child: Text(
                      lse ? "I'm new here" : "Already a user",
                      style: TextStyle(color: Colors.blueGrey, fontSize: 10.0),
                    )),
              ],
            ),
          ),
        ]),
      )),
    );
  }
}
