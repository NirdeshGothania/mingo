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
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import 'package:split_view/split_view.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  html.window.onBlur.listen((html.Event e) {
    print("Tab blurred");
    captureScreen();
  });

  html.window.onFocus.listen((html.Event e) {
    print("Tab coding");
    captureScreen();
  });

  html.window.onResize.listen((html.Event e) {
    print("Tab resized");
    captureScreen();
  });

  html.window.onPageHide.listen((html.Event e) {
    print("Tab Hide");
    captureScreen();
  });

  // Add a listener for the visibility change event (when the tab is switched).
  html.document.onVisibilityChange.listen((html.Event e) {
    if (html.document.visibilityState == 'hidden') {
      print("Tab switched");
      captureScreen();
    }
    if (html.document.visibilityState == 'visible') {
      print("Tab Focussed");
    }
  });
  runApp(const MyApp());
}

void captureScreen() {
  final html.HtmlDocument htmlDocument =
      html.window.document as html.HtmlDocument;
  final html.HtmlElement body = htmlDocument.body!;

  html.ImageElement img = html.ImageElement(
      src: 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg"/>');
  body.append(img);

  html.CanvasElement canvas = html.CanvasElement(
      width: html.window.innerWidth, height: html.window.innerHeight);
  html.CanvasRenderingContext2D context = canvas.context2D;

  // Create an ImageElement and draw it onto the canvas.
  html.ImageElement bodyImage = html.ImageElement(
      width: html.window.innerWidth, height: html.window.innerHeight);
  bodyImage.src = img.src;
  context.drawImage(bodyImage, 0, 0);

  final imgData = canvas.toDataUrl("image/png");

  img.remove();
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
  // const MyHomePage({Key? key}) : super(key: key);

  final Map<String, dynamic> contestDetails;
  MyHomePage({required this.contestDetails});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var username = TextEditingController();
  var lastname = TextEditingController();
  var email = TextEditingController();
  // var contest = contestDetails;
  bool _obscureText = true;
  CodeController? _codeController;
  var output = '';
  TextEditingController _inputController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  double leftContainerWidth = 150.0;
  SplitViewController _controller = SplitViewController();
  var submitCount = 3;
  MaterialStatesController? stateControl;
  int _clickCount = 0;
  int _maxClicks = 100;
  bool _isFullScreen = false;
  var _comment = TextEditingController();

  // final Map<String, dynamic> contestDetails;

  // MyHomePageState({required this.contestDetails});

  void _incrementClickCount() {
    _clickCount++;
    if (_clickCount >= _maxClicks) {
      _clickCount = _maxClicks;
    }
  }

  @override
  void initState() {
    super.initState();
    // Move the instantiation to initState to maintain state
    _focusNode.addListener(_handleFocusChange);
    _controller.weights = [0.73, 0.27];

    // WidgetsBinding.instance?.addObserver(this);
    final source =
        "#include<stdio.h>    \nint main() {\n    printf(\"Hello, world!\");\n    return 0;\n}";
    _codeController = CodeController(
      text: source,
      language: cpp,
    );
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      // The code editor has gained focus
      print('Code editor focused');
    } else {
      // The code editor has lost focus
      print('Code editor unfocused');
    }
  }

  // void _commentalert() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Transform.scale(
  //         scale: ModalRoute.of(context)!.animation!.value,
  //         child: AlertDialog(
  //           title: Text(
  //             'Comment',
  //             style: TextStyle(fontSize: 17),
  //           ),
  //           content: Text(
  //             'Do you want to raise any concern?',
  //             style: TextStyle(fontSize: 18),
  //           ),
  //           actions: [
  //             Container(
  //               width: 300,
  //               child: TextField(
  //                 controller: email,
  //                 decoration: InputDecoration(
  //                   hintText: 'Enter Comment',
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
  //                     Icons.comment_bank_rounded,
  //                     color: Colors.grey,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void _commentalert() {
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
                  'Comment',
                  style: TextStyle(fontSize: 17),
                ),
                content: Text(
                  'Do you want to raise any concern?',
                  style: TextStyle(fontSize: 18),
                ),
                actions: [
                  Container(
                    width: 300,
                    child: TextField(
                      controller: email,
                      decoration: InputDecoration(
                        hintText: 'Enter Comment',
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
                          Icons.comment_bank_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
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

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print('App lifecycle state changed: $state');
  //   super.didChangeAppLifecycleState(state);

  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       // App has come to the foreground
  //       print('App resumed');
  //       break;
  //     case AppLifecycleState.inactive:
  //       // App is in an inactive state, possibly transitioning between foreground and background
  //       print('App inactive');
  //       break;
  //     case AppLifecycleState.paused:
  //       // App is in the background
  //       print('App paused');
  //       break;
  //     case AppLifecycleState.detached:
  //       // App is detached (not running)
  //       print('App detached');
  //       break;
  //     case AppLifecycleState.hidden:
  //       // App is detached (not running)
  //       print('App hidden');
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final source = "void main() {\n    printf(\"Hello, world!\");\n}";
    // // Instantiate the CodeController
    // _codeController = CodeController(
    //   text: source,
    //   language: cpp,

    //   // theme: monokaiSublimeTheme,
    // );
    // return
    // VisibilityDetector(
    //   key: Key('my-app-key'),
    //   onVisibilityChanged: (info) {
    //     setState(() {
    //       if (info.visibleFraction == 1.0) {
    //         // App is not visible (minimized, split screen, or switched to another app)
    //         print('App is visible');
    //       } else {
    //         // App is visible
    //         print('App is not visible');
    //       }
    //     });
    //     setState(() {});
    //   },
    //   child:
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      _commentalert();
                    },
                    child: Icon(Icons.comment)),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFullScreen = !_isFullScreen;
                      if (_isFullScreen) {
                        FullScreenWindow.setFullScreen(true);
                      } else {
                        FullScreenWindow.setFullScreen(false);
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Start Contest',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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

          SplitView(
        viewMode: SplitViewMode.Horizontal,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contestDetails['contestName'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 10),

                SizedBox(height: 15),

                Text(
                  'Problem Statement',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 10),
                Text(widget.contestDetails['question']),
                SizedBox(height: 15),

                Text(
                  'Input Format',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 10),
                Text(widget.contestDetails['inputFormat']),
                SizedBox(height: 15),

                Text(
                  'Output Format',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 10),
                Text(widget.contestDetails['outputFormat']),
                SizedBox(height: 15),

                // Container(
                //   child: ListView.builder(
                //     itemCount: widget.contestDetails['sampleTestCases'].length,
                //     itemBuilder: (context, index) {
                //       final testCase =
                //           widget.contestDetails['sampleTestCases'][index];
                //       final input = testCase['input'].isEmpty
                //           ? ''
                //           : testCase['input'][0]['insert'];
                //       final output = testCase['output'].isEmpty
                //           ? ''
                //           : testCase['output'][0]['insert'];
                //       final explanation = testCase['explanation'].isEmpty
                //           ? ''
                //           : testCase['explanation'][0]['insert'];

                //       return ListTile(
                //         title: Text('Test Case ${index + 1}'),
                //         subtitle: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text('Input: $input'),
                //             Text('Output: $output'),
                //             Text('Explanation: $explanation'),
                //           ],
                //         ),
                //       );
                //     },
                //   ),
                // ),
                Text(
                  'Sample Test Cases',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  // width: 200,
                  height: 250,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ListView.builder(
                        itemCount:
                            widget.contestDetails['sampleTestCases'].length,
                        itemBuilder: (context, index) {
                          final testCase =
                              widget.contestDetails['sampleTestCases'][index];
                          final input = testCase['input'].isEmpty
                              ? ''
                              : testCase['input'][0]['insert'];
                          final output = testCase['output'].isEmpty
                              ? ''
                              : testCase['output'][0]['insert'];
                          final explanation = testCase['explanation'].isEmpty
                              ? ''
                              : testCase['explanation'][0]['insert'];

                          return ListTile(
                            title: Text(
                              'Test Case ${index + 1}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Input:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("$input"),
                                Text(
                                  'Output:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("$output"),
                                Text(
                                  'Explanation:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("$explanation"),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 15),

                Text(
                  'Constraints',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 10),
                Text(widget.contestDetails['constraints']),

                SizedBox(height: 15),
              ],
            ),
          ),
          // SingleChildScrollView(
          //   padding: EdgeInsets.all(16.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       // QuillEditor(
          //       //   configurations: QuillEditorConfigurations(
          //       //     controller: QuillController(
          //       //       document: Document.fromDelta(widget.contestDetails['contestName']),
          //       //       selection: const TextSelection.collapsed(offset: 0),
          //       //     ),
          //       //     readOnly: true,
          //       //   ),
          //       //   focusNode: FocusNode(),
          //       //   scrollController: ScrollController(keepScrollOffset: true),
          //       // ),
          //       Text(
          //         widget.contestDetails['contestName'],
          //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //       ),
          //       SizedBox(height: 16.0),
          //       Text(
          //         'Problem Statement:',
          //         style: TextStyle(fontWeight: FontWeight.bold),
          //       ),
          //       QuillEditor(
          //         configurations: QuillEditorConfigurations(
          //           controller: QuillController(
          //             document:
          //                 Document.fromDelta(widget.contestDetails['question']),
          //             selection: const TextSelection.collapsed(offset: 0),
          //           ),
          //           readOnly: true,
          //         ),
          //         focusNode: FocusNode(),
          //         scrollController: ScrollController(keepScrollOffset: true),
          //       ),
          //       SizedBox(height: 16.0),
          //       Text(
          //         'Input Format:',
          //         style: TextStyle(fontWeight: FontWeight.bold),
          //       ),
          //       QuillEditor(
          //         configurations: QuillEditorConfigurations(
          //           controller: QuillController(
          //             document: Document.fromDelta(
          //                 widget.contestDetails['inputFormat']),
          //             selection: const TextSelection.collapsed(offset: 0),
          //           ),
          //           readOnly: true,
          //         ),
          //         focusNode: FocusNode(),
          //         scrollController: ScrollController(keepScrollOffset: true),
          //       ),
          //       SizedBox(height: 16.0),
          //       Text(
          //         'Output Format:',
          //         style: TextStyle(fontWeight: FontWeight.bold),
          //       ),
          //       QuillEditor(
          //         configurations: QuillEditorConfigurations(
          //           controller: QuillController(
          //             document: Document.fromDelta(
          //                 widget.contestDetails['outputFormat']),
          //             selection: const TextSelection.collapsed(offset: 0),
          //           ),
          //           readOnly: true,
          //         ),
          //         focusNode: FocusNode(),
          //         scrollController: ScrollController(keepScrollOffset: true),
          //       ),
          //       SizedBox(height: 16.0),
          //       Text(
          //         'Sample Test Cases:',
          //         style: TextStyle(fontWeight: FontWeight.bold),
          //       ),
          //       Container(
          //         child: QuillEditor(
          //           configurations: QuillEditorConfigurations(
          //             controller: QuillController(
          //               document: Document.fromDelta(
          //                   widget.contestDetails['sampleTestCases']),
          //               selection: const TextSelection.collapsed(offset: 0),
          //             ),
          //             readOnly: true,
          //           ),
          //           focusNode: FocusNode(),
          //           scrollController: ScrollController(keepScrollOffset: true),
          //         ),
          //         color: Colors.blue.shade50,
          //       ),
          //       SizedBox(height: 16.0),
          //       // Text(
          //       //   'Explanation:',
          //       //   style: TextStyle(fontWeight: FontWeight.bold),
          //       // ),
          //       // QuillEditor(
          //       //   configurations: QuillEditorConfigurations(
          //       //     controller: QuillController(
          //       //       document: Document.fromDelta(explanation),
          //       //       selection: const TextSelection.collapsed(offset: 0),
          //       //     ),
          //       //     readOnly: true,
          //       //   ),
          //       //   focusNode: FocusNode(),
          //       //   scrollController: ScrollController(keepScrollOffset: true),
          //       // ),
          //       // SizedBox(height: 16.0),
          //       Text(
          //         'Constraints:',
          //         style: TextStyle(fontWeight: FontWeight.bold),
          //       ),
          //       QuillEditor(
          //         configurations: QuillEditorConfigurations(
          //           controller: QuillController(
          //             document: Document.fromDelta(
          //                 widget.contestDetails['constraints']),
          //             selection: const TextSelection.collapsed(offset: 0),
          //           ),
          //           readOnly: true,
          //         ),
          //         focusNode: FocusNode(),
          //         scrollController: ScrollController(keepScrollOffset: true),
          //       ),
          //       SizedBox(height: 16.0),
          //     ],
          //   ),
          // ),
          Container(
            // height: double.infinity,
            
            child: SplitView(
              // gripSize: 6, // Size of the grip
              controller: _controller,
              viewMode: SplitViewMode.Vertical,
              children: [
                Expanded(
                  // flex: 7,
                  child: SingleChildScrollView(
                    child: Container(
                      child: CodeTheme(
                        data: CodeThemeData(
                          styles: monokaiSublimeTheme,
                        ),
                        child: CodeField(
                          focusNode: _focusNode,
                          controller: _codeController!,
                          textStyle: TextStyle(fontFamily: 'SourceCode'),
                          maxLines: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Input',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  _controller.weights = [0.3, 0.7];
                                  setState(() {});
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
                                    SizedBox(width: 5),

                                    // Adjust the spacing as needed

                                    Text(
                                      'Run',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: 150,
                                    child: ElevatedButton(
                                      onPressed: _clickCount < _maxClicks
                                          ? () {
                                              _controller.weights = [0.3, 0.8];
                                              // submitCount--;
                                              // if (submitCount == 0) {
                                              //   stateControl = null;
                                              // }
                                              setState(() {});
                                              final res = _codeController?.text
                                                  .toString();
                                              // final inp = _inputController.text.toString();
                                              print(res);
                                              // print(inp);
                                              test(res);
                                              _incrementClickCount();
                                            }
                                          : null,

                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.green,
                                      ),
                                      // statesController: stateControl,
                                      // statesController: null,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.play_arrow,
                                            size: 20,
                                          ),
                                          // SizedBox(width: 5),

                                          // Adjust the spacing as needed

                                          Text(
                                            'Submit',
                                            style: TextStyle(
                                                // fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '${_clickCount} / ${_maxClicks}',
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: ElevatedButton(
                                  onPressed: () {
                                    _controller.weights = [0.73, 0.27];
                                    setState(() {});
                                  },
                                  child: Icon(
                                      Icons.arrow_drop_down_circle_outlined)),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 25,
                        // ),

                        SizedBox(
                          height: 11,
                        ),
                        Container(
                          color: Colors.black,
                          child: TextField(
                            controller: _inputController,
                            maxLines: 7,
                            style: TextStyle(color: Colors.white),

                            //   decoration: InputDecoration(
                            //     labelText: 'Input',

                            // ),
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
                        ),
                      ],
                    ),
                  ),
                ),
                // till here
              ],
            ),
          ),
        ],
      ),
    );
    // setState(() {});
  }

  Future<void> runCode(String? code, String input) async {
    final serverUrl =
        'https://proj-server.onrender.com/runcode'; // Replace with your server URL

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

  Future<void> test(String? code) async {
    final serverUrl =
        'https://proj-server.onrender.com/test'; // Replace with your server URL

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
        body: jsonEncode({'code': code}),
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

  // @override
  // void dispose() {
  //   WidgetsBinding.instance?.removeObserver(this);
  //   super.dispose();
  //   _inputController.dispose();
  // }
}
