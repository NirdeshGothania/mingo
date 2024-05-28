import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mingo/common_widgets.dart';

import 'utils/utils.dart';

class ForgotpasswordPage1 extends StatefulWidget {
  const ForgotpasswordPage1({super.key});

  @override
  State<ForgotpasswordPage1> createState() => ForgotpasswordPage();
}

class ForgotpasswordPage extends State<ForgotpasswordPage1> {
  var email = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppbar(
          title: Text(
            'Reset Password',
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Enter Registered Email',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 300,
                child: CustomTextField(
                  controller: email,
                  hintText: 'Email',
                  iconData: Icons.email,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              FilledButton.icon(
                  onPressed: () {
                    auth
                        .sendPasswordResetEmail(email: email.text.toString())
                        .then((value) {
                      Utils().toastMessage(
                          'Reset Password link sent to your email id!');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.send),
                  label: const Text("Submit"))
            ],
          ),
        ));
  }
}
