import 'dart:async';
import 'dart:collection';
import 'package:mingo/main.dart';
import 'package:flutter/material.dart';
import 'package:mingo/ContestPage.dart';
import 'package:mingo/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class StudentPage1 extends StatefulWidget {
  @override
  State<StudentPage1> createState() => StudentPage();
}

class StudentPage extends State<StudentPage1> {
  final _auth = FirebaseAuth.instance;
  final LinkedHashMap<Delta, dynamic> contestDetails =
      LinkedHashMap<Delta, dynamic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Student Page',
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
            child: Text('Sign Out'),
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('Contest').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              // var contestDetails;
              final contests = snapshot.data!.docs;
              return ListView.builder(
                itemCount: contests.length,
                itemBuilder: (context, index) {
                  final contest = contests[index];
                  final contestData = contest.data() as Map<String, dynamic>;
                  print(contestData);
                  print(contestData.runtimeType);
                  final contestName = contestData['contestName'];
                  return ListTile(
                    title: Text(contestName),
                    subtitle: Text(
                        "Start Date: ${contestData['startDate']}"), // Add additional information as needed
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MyHomePage(contestDetails: contestData),
                          ),
                        );
                      },
                      child: Text("Enter Contest"),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
