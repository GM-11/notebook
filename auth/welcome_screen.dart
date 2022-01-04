import 'package:flutter/material.dart';
import 'package:notebook/auth/auth_screens/details.dart';
import 'package:notebook/auth/auth_screens/register.dart';
import 'package:notebook/paints/backgrounds.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WPG(),
      child: Scaffold(
        body: Stack(
          children: [
            TweenAnimationBuilder(
              duration: Duration(milliseconds: 1000),
              tween: Tween<double>(begin: 0, end: 1),
              curve: Curves.decelerate,
              builder: (context, _val, child) {
                return Opacity(
                  opacity: _val,
                  child: Padding(
                      child: child, padding: EdgeInsets.only(right: _val * 30)),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 180.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                          color: Colors.cyan[800],
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "to Notebook",
                      style: TextStyle(
                          color: Colors.cyan[800],
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: Text(
                      "Tap to continue",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: 40.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

PageController _pageController = PageController();

class _AuthenticateState extends State<Authenticate> {
  List pagesList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
              onTap: () {
                _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInSine);
              },
              child: Welcome()),
          DetailsPage(),
          Register(),
        ],
      ),
    );
  }
}
