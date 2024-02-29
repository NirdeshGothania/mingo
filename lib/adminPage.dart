import 'dart:async';
// import 'package:mingo/main.dart';
import 'package:flutter/material.dart';
import 'package:mingo/ContestPage.dart';
import 'package:mingo/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:firebase_database/firebase_database.dart';

class adminPage1 extends StatefulWidget {
  @override
  State<adminPage1> createState() => adminPage();
}

class adminPage extends State<adminPage1> {
  final _auth = FirebaseAuth.instance;
  // @override
  // void initState() {
  //   super.initState();
  //   Timer(Duration(seconds: 2), () {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => ContestPage(),
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Admin Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          ElevatedButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => loginPage1(),
                  ),
                );
              },
              child: Text('Sign Out')),
        ],
      ),
      body: Container(
        color: Colors.blue,
        child: Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContestPage1(contestName: Delta()..insert('\n'),
        question: Delta()..insert('\n'),
        inputFormat: Delta()..insert('\n'),
        outputFormat: Delta()..insert('\n'),
        sampleTestCases: Delta()..insert('\n'),
        // explanation: Delta()..insert('\n'),
        constraints: Delta()..insert('\n'),),
                    ),
                  );
                },
                child: Text('Create Contest'))),
      ),
    );
  }
}
