import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'utils/utils.dart';

class forgotpasswordPage1 extends StatefulWidget {
  const forgotpasswordPage1({super.key});

  @override
  State<forgotpasswordPage1> createState() => forgotpasswordPage();
}

class forgotpasswordPage extends State<forgotpasswordPage1> {
  var email = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Reset Password',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff2b2d7f),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    auth
                        .sendPasswordResetEmail(email: email.text.toString())
                        .then((value) {
                      Utils().toastMessage(
                          'Reset Password link sent to your email id!');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text("Submit"))
            ],
          ),
        ));
  }
}
