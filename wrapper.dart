import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notebook/auth/auth_screens/register.dart';
import 'package:notebook/auth/welcome_screen.dart';
import 'package:notebook/screens/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return user == null ? Authenticate() : Home();
  }
}
