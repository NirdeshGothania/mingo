import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mingo/adminPage.dart';
import 'package:mingo/forgotpasswordPage.dart';
import 'package:mingo/signupPage.dart';
import 'package:mingo/studentPage.dart';
import 'package:mingo/test.dart';

import 'sessionConstants.dart';

class loginPage1 extends StatefulWidget {
  const loginPage1({super.key});

  @override
  State<loginPage1> createState() => loginPage();
}

class loginPage extends State<loginPage1> {
  var rollnumber = TextEditingController();
  var password = TextEditingController();
  var email = TextEditingController();
  bool isLoading = false; // Add loading state variable

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
    setState(() {
      isLoading = true; // Set loading state to true
    });
    const serverUrl = '${sessionConstants.host}/createuser';
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value);
      print('User present');
      login1(email, password);
    }).onError((error, stackTrace) {
      toastMessage(error.toString());
      setState(() {
        isLoading = false; // Set loading state to false on error
      });
    });
  }

  void login1(String email, String password) async {
    const serverUrl =
        '${sessionConstants.host}/login'; // Assuming this is your login endpoint
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
          sessionConstants.email = email;
          // Navigate to admin page if user is an admin
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const adminPage1()));
        } else {
          // Navigate to regular user page if user is not an admin
          sessionConstants.email2 = email;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const StudentPage1()));
        }
      } else {
        // Handle error response from server
        toastMessage(response.body);
      }
    } catch (error) {
      // Handle network or other errors
      toastMessage(error.toString());
    } finally {
      setState(() {
        isLoading = false; // Set loading state to false after request completes
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
        backgroundColor: const Color(0xff2b2d7f),
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
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: const BorderSide(
                      color: Color(0xff2b2d7f),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 172, 24, 14),
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
                obscureText: true,
                controller: password,
                onSubmitted: (_) {
                  String emailF = email.text;
                  String passwordF = password.text;

                  login(emailF, passwordF);
                },
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: const BorderSide(
                      color: Color(0xff2b2d7f),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 172, 24, 14),
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
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    // alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const forgotpasswordPage1()),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Color(0xff2b2d7f),
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              width: 100,
              height: 40, // Adjust button height
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        String emailF = email.text;
                        String passwordF = password.text;

                        login(emailF, passwordF);
                      },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    // Button color based on the state
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey; // Disable color
                    }
                    return const Color(0xff2b2d7f); // Normal color
                  }),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!isLoading)
                      const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ), // Show login text if not loading
                    if (isLoading)
                      const SizedBox(
                        width:
                            20, // Adjust the width of the CircularProgressIndicator
                        height:
                            20, // Adjust the height of the CircularProgressIndicator
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ), // Show loading indicator if loading
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Align(
            //   alignment: Alignment.center,
            //   child: TextButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => forgotpasswordPage1()));
            //     },
            //     child: Text(
            //       "Forgot Password?",
            //       style: TextStyle(
            //           color: Color(0xff2b2d7f), fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't Have an account?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const signupPage1()));
                    },
                    child: const Text(
                      'SignUp',
                      style: TextStyle(color: Color(0xff2b2d7f)),
                    ))
              ],
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QuillTest()));
                },
                child: const Text(
                  'Test',
                  style: TextStyle(color: Color(0xff2b2d7f)),
                )),

            Container(
              margin: const EdgeInsets.all(8.0),
              width: 100,
              height: 40, // Adjust button height
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        String emailF = "cs21b1067@iiitr.ac.in";
                        String passwordF = '123456789';

                        login(emailF, passwordF);
                      },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    // Button color based on the state
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey; // Disable color
                    }
                    return const Color(0xff2b2d7f); // Normal color
                  }),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!isLoading)
                      const Text(
                        'Admin Login',
                        style: TextStyle(color: Colors.white),
                      ), // Show login text if not loading
                    if (isLoading)
                      const SizedBox(
                        width:
                            20, // Adjust the width of the CircularProgressIndicator
                        height:
                            20, // Adjust the height of the CircularProgressIndicator
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ), // Show loading indicator if loading
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.all(8.0),
              width: 100,
              height: 40, // Adjust button height
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        String emailF = "cs21b1016@iiitr.ac.in";
                        String passwordF = '123456789';

                        login(emailF, passwordF);
                      },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    // Button color based on the state
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey; // Disable color
                    }
                    return const Color(0xff2b2d7f); // Normal color
                  }),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!isLoading)
                      const Text(
                        'Student Login',
                        style: TextStyle(color: Colors.white),
                      ), // Show login text if not loading
                    if (isLoading)
                      const SizedBox(
                        width:
                            20, // Adjust the width of the CircularProgressIndicator
                        height:
                            20, // Adjust the height of the CircularProgressIndicator
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ), // Show loading indicator if loading
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
