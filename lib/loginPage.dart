import 'dart:async';
import 'package:mingo/adminPage.dart';
import 'package:mingo/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mingo/signupPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mingo/studentPage.dart';

class loginPage1 extends StatefulWidget {
  @override
  State<loginPage1> createState() => loginPage();
}

class loginPage extends State<loginPage1> {
  var rollnumber = TextEditingController();
  var password = TextEditingController();
  var email = TextEditingController();

  final _auth = FirebaseAuth.instance;

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void login(String email, String password) {
    final serverUrl = 'https://proj-server.onrender.com/createuser';
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print('User present');
      login1(email, password);
    }).onError((error, stackTrace) {
      toastMessage(error.toString());
    });
  }

  void login1(String email, String password) async {
    final serverUrl =
        'https://proj-server.onrender.com/login'; // Assuming this is your login endpoint
    try {
      final response = await http.post(Uri.parse(serverUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password,
          }));

      if (response.statusCode == 200) {
        final responseData = response.body;
        print(responseData);
        if (responseData == 'isAdmin') {
          // Navigate to admin page if user is an admin
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => adminPage1()));
        } else {
          // Navigate to regular user page if user is not an admin
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => StudentPage1()));
        }
      } else {
        // Handle error response from server
        toastMessage(response.body);
      }
    } catch (error) {
      // Handle network or other errors
      toastMessage(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Login Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Welcome to The Code Arena!',
                style: TextStyle(fontSize: 21),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 300,
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: BorderSide(
                      color: Colors.deepOrange,
                      width: 2,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.supervised_user_circle_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Container(
              height: 11,
            ),
            Container(
              width: 300,
              child: TextField(
                obscureText: true,
                controller: password,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: BorderSide(
                      color: Colors.deepOrange,
                      width: 2,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.supervised_user_circle_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  String email_f = email.text.toLowerCase();
                  String password_f = password.text.toLowerCase();

                  login(email_f, password_f);
                },
                child: Text('Login'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't Have an account?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => signupPage1()));
                    },
                    child: Text(
                      'SignUp',
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
