import 'dart:async';
import 'package:mingo/main.dart';
import 'package:flutter/material.dart';

class SplashPage1 extends StatefulWidget {
  @override
  State<SplashPage1> createState() => SplashPage();
}

class SplashPage extends State<SplashPage1> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Text(
            'CODE ARENA',
            style: TextStyle(
                fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
