import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mingo/common_widgets.dart';
import 'package:mingo/loginPage.dart';

import 'sessionConstants.dart';

// import 'package:firebase_auth/firebase_auth.dart';

class SignupPage1 extends StatefulWidget {
  const SignupPage1({super.key});

  @override
  State<SignupPage1> createState() => SignupPage();
}

class SignupPage extends State<SignupPage1> {
  var rollnumber = TextEditingController();
  var name = TextEditingController();
  var password = TextEditingController();
  var email = TextEditingController();
  bool isLoading = false;

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
    setState(() {
      isLoading = true;
    });
    if (rollnumber == '' || name == '' || email == '' || password == '') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(title: Text('Fill the required fields'));
          });
      setState(() {
        isLoading = false;
      });
    } else {
      FirebaseAuth auth = FirebaseAuth.instance;
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const loginPage1()));
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        toastMessage(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        automaticallyImplyLeading: true,
        title: Text(
          'SignUp Page',
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
                controller: rollnumber,
                hintText: 'Roll number',
                iconData: Icons.numbers,
              ),
              Container(
                height: 11,
              ),
              CustomTextField(
                controller: name,
                hintText: 'Name',
                iconData: Icons.supervised_user_circle,
              ),
              Container(
                height: 11,
              ),
              CustomTextField(
                controller: email,
                hintText: 'Email',
                iconData: Icons.email,
              ),
              Container(
                height: 11,
              ),
              CustomTextField(
                controller: password,
                hintText: 'Password',
                iconData: Icons.password,
                obscureText: true,
                onSubmitted: (p0) {
                  String nameF = name.text.toString();
                  String rollnumberF = rollnumber.text.toString();
                  String emailF = email.text.toString();
                  String passwordF = password.text.toString();

                  register(rollnumberF, nameF, emailF, passwordF);
                  signUp(rollnumberF, nameF, emailF, passwordF);
                },
              ),
              Container(
                height: 11,
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                width: 150,
                child: FilledButton.icon(
                  onPressed: isLoading
                      ? null
                      : () {
                          String nameF = name.text.toString();
                          String rollnumberF = rollnumber.text.toString();
                          String emailF = email.text.toString();
                          String passwordF = password.text.toString();

                          register(rollnumberF, nameF, emailF, passwordF);
                          signUp(rollnumberF, nameF, emailF, passwordF);
                        },
                  icon: const Icon(Icons.person_add_alt),
                  label: (isLoading)
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'SignUp',
                        ),
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
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register(
      String? rollnumber, String? name, String? email, String? password) async {
    setState(() {
      isLoading = true; // Set loading state to true
    });
    const serverUrl =
        '${SessionConstants.host}/createuser'; // Replace with your server URL

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

      if (response.statusCode == 200) {
        print('Success!');

        var responseBody = response.body;
        print('Response body: $responseBody');
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Exception: $e');
    }
  }
}
