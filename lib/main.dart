// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//         textTheme: TextTheme(
//           displayMedium: TextStyle(
//               fontSize: 21,
//               fontWeight: FontWeight.w500,
//               fontStyle: FontStyle.italic),
//           titleSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
//           displaySmall: TextStyle(
//               fontSize: 21,
//               fontWeight: FontWeight.w500,
//               fontStyle: FontStyle.italic,
//               color: Colors.orange),
//         ),
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   var username = TextEditingController();
//   var lastname = TextEditingController();
//   var email = TextEditingController(); // Add this line

//   // Function to show the birthday popup
//   void showBirthdayPopup() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             '🎊Happy birthday Khushi!🎊',
//             style: TextStyle(fontSize: 17),
//           ),
//           content: Text(
//             'May god fulfill all your wishes😊',
//             style: TextStyle(fontSize: 18),
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Next'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void notBirthdayPopup() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Coming Soon....'),
//           content: Text('Enjoy your day!'),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Flutter Container',
//           style: TextStyle(
//             fontSize: 21,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.blue,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 300,
//               child: TextField(
//                 controller: username,
//                 decoration: InputDecoration(
//                   hintText: 'Enter Firstname',
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(21),
//                     borderSide: BorderSide(
//                       color: Colors.blue,
//                       width: 2,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(21),
//                     borderSide: BorderSide(
//                       color: Colors.deepOrange,
//                       width: 2,
//                     ),
//                   ),
//                   prefixIcon: Icon(
//                     Icons.supervised_user_circle_outlined,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: 11,
//             ),
//             Container(
//               width: 300,
//               child: TextField(
//                 controller: lastname,
//                 decoration: InputDecoration(
//                   hintText: 'Enter Lastname',
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(21),
//                     borderSide: BorderSide(
//                       color: Colors.blue,
//                       width: 2,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(21),
//                     borderSide: BorderSide(
//                       color: Colors.deepOrange,
//                       width: 2,
//                     ),
//                   ),
//                   prefixIcon: Icon(
//                     Icons.supervised_user_circle_outlined,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.all(8.0),
//               width: 100,
//               child: ElevatedButton(
//                 onPressed: () {
//                   String firstName = username.text.toLowerCase();
//                   String lastName = lastname.text.toLowerCase();

//                   if (firstName == 'khushi' && lastName == 'pandit') {
//                     // Show birthday popup for Khushi
//                     showBirthdayPopup();
//                   } else {
//                     // Perform other actions or validations as needed
//                     String uname = username.text.toString();
//                     String uemail = email.text; // Fix here

//                     notBirthdayPopup();

//                     print("Name: $uname, Email: $uemail");
//                   }
//                 },
//                 child: Text('Login'),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:mingo/SplashPage.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: TextTheme(
          displayMedium: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic),
          titleSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: Colors.orange),
        ),
      ),
      home: SplashPage1(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var username = TextEditingController();
  var lastname = TextEditingController();
  var email = TextEditingController();
  bool _obscureText = true;
  CodeController? _codeController;
  var output = '';
  TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Move the instantiation to initState to maintain state
    final source = "void main() {\n    printf(\"Hello, world!\");\n}";
    _codeController = CodeController(
      text: source,
      language: cpp,
    );
  }

  // Function to show the celebration birthday popup
  void showBirthdayPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedBuilder(
          animation: CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeInOutBack,
          ),
          builder: (context, child) {
            return Transform.scale(
              scale: ModalRoute.of(context)!.animation!.value,
              child: AlertDialog(
                title: Text(
                  'Login Successful!',
                  style: TextStyle(fontSize: 17),
                ),
                content: Text(
                  'Coming Soon....',
                  style: TextStyle(fontSize: 18),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void notBirthdayPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User no registered!'),
          content: Text('Enjoy your day!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final source = "void main() {\n    printf(\"Hello, world!\");\n}";
    // // Instantiate the CodeController
    // _codeController = CodeController(
    //   text: source,
    //   language: cpp,

    //   // theme: monokaiSublimeTheme,
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Code Arena',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body:
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Container(
          //         width: 300,
          //         child: TextField(
          //           controller: username,
          //           decoration: InputDecoration(
          //             hintText: 'Enter Roll number',
          //             enabledBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(21),
          //               borderSide: BorderSide(
          //                 color: Colors.blue,
          //                 width: 2,
          //               ),
          //             ),
          //             focusedBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(21),
          //               borderSide: BorderSide(
          //                 color: Colors.deepOrange,
          //                 width: 2,
          //               ),
          //             ),
          //             prefixIcon: Icon(
          //               Icons.supervised_user_circle_outlined,
          //               color: Colors.grey,
          //             ),
          //           ),
          //         ),
          //       ),
          //       Container(
          //         height: 11,
          //       ),
          //       // Container(
          //       //   width: 300,
          //       //   child: TextField(
          //       //     controller: lastname,
          //       //     obscureText: true,
          //       //     decoration: InputDecoration(
          //       //       hintText: 'Password',
          //       //       enabledBorder: OutlineInputBorder(
          //       //         borderRadius: BorderRadius.circular(21),
          //       //         borderSide: BorderSide(
          //       //           color: Colors.blue,
          //       //           width: 2,
          //       //         ),
          //       //       ),
          //       //       focusedBorder: OutlineInputBorder(
          //       //         borderRadius: BorderRadius.circular(21),
          //       //         borderSide: BorderSide(
          //       //           color: Colors.deepOrange,
          //       //           width: 2,
          //       //         ),
          //       //       ),
          //       //       prefixIcon: Icon(
          //       //         Icons.key_rounded,
          //       //         color: Colors.grey,
          //       //       ),
          //       //       suffixIcon: IconButton(
          //       //           onPressed: () {
          //       //             obscureText:
          //       //             false;
          //       //             setState(() {});
          //       //           },
          //       //           icon: Icon(
          //       //             Icons.remove_red_eye_rounded,
          //       //           )),
          //       //     ),
          //       //   ),
          //       // ),
          //       Container(
          //         width: 300,
          //         child: TextField(
          //           controller: lastname,
          //           obscureText: _obscureText, // Use a state variable here
          //           decoration: InputDecoration(
          //             hintText: 'Password',
          //             enabledBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(21),
          //               borderSide: BorderSide(
          //                 color: Colors.blue,
          //                 width: 2,
          //               ),
          //             ),
          //             focusedBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(21),
          //               borderSide: BorderSide(
          //                 color: Colors.deepOrange,
          //                 width: 2,
          //               ),
          //             ),
          //             prefixIcon: Icon(
          //               Icons.key_rounded,
          //               color: Colors.grey,
          //             ),
          //             suffixIcon: IconButton(
          //               onPressed: () {
          //                 setState(() {
          //                   _obscureText =
          //                       !_obscureText; // Toggle the state variable
          //                 });
          //               },
          //               icon: Icon(
          //                 _obscureText
          //                     ? Icons.visibility_off_rounded
          //                     : Icons.visibility_rounded,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       Container(
          //         margin: const EdgeInsets.all(8.0),
          //         width: 100,
          //         child: ElevatedButton(
          //           onPressed: () {
          //             String firstName = username.text.toLowerCase();
          //             String lastName = lastname.text.toLowerCase();

          //             if (firstName == 'nirdesh' && lastName == 'gothania') {
          //               showBirthdayPopup();
          //             } else {
          //               // Perform other actions or validations as needed
          //               String uname = username.text.toString();
          //               String uemail = email.text;
          //               notBirthdayPopup();

          //               print("Name: $uname, Email: $uemail");
          //             }
          //           },
          //           child: Text(
          //             'Login',
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),

          SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: CodeTheme(
                data: CodeThemeData(
                  styles: monokaiSublimeTheme,
                ),
                child: CodeField(
                  controller: _codeController!,
                  textStyle: TextStyle(fontFamily: 'SourceCode'),
                  maxLines: 25,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Input',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              height: 11,
            ),
            Container(
              color: Colors.black,
              child: TextField(
                controller: _inputController,
                maxLines: 5,
                style: TextStyle(color: Colors.white),

                //   decoration: InputDecoration(
                //     labelText: 'Input',

                // ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  final res = _codeController?.text.toString();
                  final inp = _inputController.text.toString();
                  print(res);
                  print(inp);
                  runCode(res, inp);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.pink,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow,
                      size: 20,
                    ),
                    SizedBox(width: 8),

                    // Adjust the spacing as needed

                    Text(
                      'Run',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Output',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              height: 11,
            ),
            Container(
              height: 400,
              width: double.infinity,
              child: Text(
                '$output',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  Future<void> runCode(String? code, String input) async {
    final serverUrl =
        'http://localhost:3000/runcode'; // Replace with your server URL

    // try {
    //   print('hello');
    //   var response = await http.post(
    //     Uri.parse(serverUrl),
    //     body: code,
    //   );
    //   print('hello');
    //   // print(response);
    //   if (response.statusCode == 200) {
    //     print('Output: ${response.body}');
    //     // Update the UI with the output if needed
    //   } else {
    //     print('Error: ${response.body}');
    //     // Handle error and update the UI accordingly
    //   }
    // } catch (e) {
    //   print('Exception: $e');
    //   // Handle exception and update the UI accordingly
    // }
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code, 'input': input}),
      );
      output = '';
      output = output + response.body;
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
      setState(() {});
    } catch (e) {
      print('Exception: $e');
      // Handle exception and update the UI accordingly
    }
    // setState(() {});
  }
}
