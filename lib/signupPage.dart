import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mingo/loginPage.dart';

// import 'package:firebase_auth/firebase_auth.dart';

class signupPage1 extends StatefulWidget {
  const signupPage1({super.key});

  @override
  State<signupPage1> createState() => signupPage();
}

class signupPage extends State<signupPage1> {
  var rollnumber = TextEditingController();
  var name = TextEditingController();
  var password = TextEditingController();
  var email = TextEditingController();

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

  signUp(String rollnumber, String name, String email, String password) async {
    if (rollnumber == '' || name == '' || email == '' || password == '') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(title: Text('Fill the required fields'));
          });
    } else {
      FirebaseAuth auth = FirebaseAuth.instance;
      // try {
      //   userCredential = await FirebaseAuth.instance
      //       .createUserWithEmailAndPassword(email: email, password: password);

      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => const MyHomePage()));
      // } on FirebaseAuthException catch (ex) {
      //   return showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return AlertDialog(title: Text('Fill the required fields'));
      //       });
      // }

      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const loginPage1()));
      }).onError((error, stackTrace) {
        toastMessage(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
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
              child: const Text(
                'Welcome to The Code Arena!',
                style: TextStyle(fontSize: 21),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: rollnumber,
                decoration: InputDecoration(
                  hintText: 'Enter RollNumber',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 2,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.supervised_user_circle_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Container(
              height: 11,
            ),
            SizedBox(
              width: 300,
              child: TextField(
                // obscureText: true,
                controller: name,
                decoration: InputDecoration(
                  hintText: 'Enter Name',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 2,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.supervised_user_circle_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Container(
              height: 11,
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 2,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.supervised_user_circle_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Container(
              height: 11,
            ),
            SizedBox(
              width: 300,
              child: TextField(
                controller: password,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 2,
                    ),
                  ),
                  prefixIcon: const Icon(
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
              margin: const EdgeInsets.all(8.0),
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  String nameF = name.text.toString();
                  String rollnumberF = rollnumber.text.toString();
                  String emailF = email.text.toString();
                  String passwordF = password.text.toString();

                  register(rollnumberF, nameF, emailF, passwordF);
                  signUp(rollnumberF, nameF, emailF, passwordF);
                  // setState(() {});
                },
                child: const Text('SignUp'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already Have an Account?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const loginPage1()));
                    },
                    child: const Text(
                      'Login',
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

Future<void> register(
    String? rollnumber, String? name, String? email, String? password) async {
  const serverUrl =
      'https://proj-server.onrender.com/createuser'; // Replace with your server URL

  try {
    final response = await http.post(
      Uri.parse(serverUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'rollnumber': rollnumber,
        'name': name,
        'email': email,
        'password': password,
        'role': 0,
      }),
    );
    // output = '';
    // output = output + response.body;
    // Check the status code
    if (response.statusCode == 200) {
      print(
          'Success!'); // You can replace this with your desired success handling logic

      // Read the response body
      var responseBody = response.body;
      print('Response body: $responseBody');
      // You can handle or process the response body as needed
    } else {
      print('Error: ${response.statusCode}');
      print('Error message: ${response.body}');
      // Handle the error and update the UI accordingly
    }
    // setState(() {});
  } catch (e) {
    print('Exception: $e');
    // Handle exception and update the UI accordingly
  }
  // setState(() {});
}
