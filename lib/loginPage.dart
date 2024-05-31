import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mingo/adminPage.dart';
import 'package:mingo/common_widgets.dart';
import 'package:mingo/forgot_passwordPage.dart';
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
    const serverUrl = '${SessionConstants.host}/createuser';
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

  void login1(String email, String password) {
    const serverUrl =
        '${SessionConstants.host}/login'; // Assuming this is your login endpoint
    try {
      http
          .post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      )
          .then((response) {
        if (response.statusCode == 200) {
          var responseData = response.body;
          print(responseData);
          if (responseData == 'isAdmin') {
            SessionConstants.email = email;
            // Navigate to admin page if user is an admin
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminPage1()),
            );
          } else {
            // Navigate to regular user page if user is not an admin
            SessionConstants.email2 = email;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StudentPage1()),
            );
          }
        } else {
          // Handle error response from server
          toastMessage(response.body);
        }
      });
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
      appBar: const CustomAppbar(
        automaticallyImplyLeading: false,
        title: Text(
          'Login Page',
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to The Code Arena!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                controller: email,
                iconData: Icons.email,
                hintText: 'Email',
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextField(
                obscureText: true,
                controller: password,
                iconData: Icons.password,
                hintText: 'Password',
                onSubmitted: (_) {
                  String emailF = email.text;
                  String passwordF = password.text;

                  login(emailF, passwordF);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    // alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotpasswordPage1(),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                      ),
                    ),
                  ),
                ],
              ),
              FilledButton.icon(
                onPressed: isLoading
                    ? null
                    : () {
                        String emailF = email.text;
                        String passwordF = password.text;

                        login(emailF, passwordF);
                      },
                icon: const Icon(Icons.login),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (isLoading)
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Login',
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
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
                            builder: (context) => const SignupPage1(),
                          ),
                        );
                      },
                      child: const Text(
                        'SignUp',
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              FilledButton(
                onPressed: isLoading
                    ? null
                    : () {
                        String emailF = "cs21b1067@iiitr.ac.in";
                        String passwordF = '123456789';

                        login(emailF, passwordF);
                      },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!isLoading)
                      const Text(
                        'Admin Login',
                      ),
                    if (isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FilledButton(
                onPressed: isLoading
                    ? null
                    : () {
                        String emailF = "cs21b1016@iiitr.ac.in";
                        String passwordF = '123456789';

                        login(emailF, passwordF);
                      },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!isLoading)
                      const Text(
                        'Student Login',
                      ),
                    if (isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
              // FilledButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const TableView(),
              //         ),
              //       );
              //     },
              //     child: const Text('Test'))
            ],
          ),
        ),
      ),
    );
  }
}
