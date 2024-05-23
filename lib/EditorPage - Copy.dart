import 'dart:convert';
import 'dart:html' as html;

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:http/http.dart' as http;
import 'package:split_view/split_view.dart';

class MyHomePage__ extends StatefulWidget {
  // const MyHomePage({Key? key}) : super(key: key);

  final Map<String, dynamic> contestDetails;
  const MyHomePage__({super.key, required this.contestDetails});

  @override
  MyHomePage__State createState() => MyHomePage__State();
}

class MyHomePage__State extends State<MyHomePage__> {
  var username = TextEditingController();
  var lastname = TextEditingController();
  var email = TextEditingController();
  // var contest = contestDetails;
  final bool _obscureText = true;
  CodeController? _codeController;
  var output = '';
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  double leftContainerWidth = 150.0;
  final SplitViewController _controller = SplitViewController();
  var submitCount = 3;
  MaterialStatesController? stateControl;
  int _clickCount = 0;
  final int _maxClicks = 100;
  bool _isFullScreen = false;
  final _comment = TextEditingController();
  var count = 0;
  // var diffIcon = const Icon(Icons.arrow_drop_down_circle_outlined);

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
    Future.delayed(const Duration(milliseconds: 10)).then((value) {
      FullScreenWindow.setFullScreen(true);
    });

    

    // WidgetsBinding.instance?.addObserver(this);
    const source =
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
                title: const Text(
                  'Comment',
                  style: TextStyle(fontSize: 17),
                ),
                content: const Text(
                  'Do you want to raise any concern?',
                  style: TextStyle(fontSize: 18),
                ),
                actions: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: email,
                      decoration: InputDecoration(
                        hintText: 'Enter Comment',
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
                    child: const Text('OK'),
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
                title: const Text(
                  'Login Successful!',
                  style: TextStyle(fontSize: 17),
                ),
                content: const Text(
                  'Coming Soon....',
                  style: TextStyle(fontSize: 18),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
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
          title: const Text('User no registered!'),
          content: const Text('Enjoy your day!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
                    child: const Icon(Icons.comment)),
                const SizedBox(
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
                  child: const Row(
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
      body: SplitView(
        viewMode: SplitViewMode.Horizontal,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contestDetails['contestName'],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 10),

                const SizedBox(height: 15),

                const Text(
                  'Problem Statement',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 10),
                Text(widget.contestDetails['question']),
                const SizedBox(height: 15),

                const Text(
                  'Input Format',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 10),
                Text(widget.contestDetails['inputFormat']),
                const SizedBox(height: 15),

                const Text(
                  'Output Format',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 10),
                Text(widget.contestDetails['outputFormat']),
                const SizedBox(height: 15),
                const Text(
                  'Sample Test Cases',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Input:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("$input"),
                                const Text(
                                  'Output:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("$output"),
                                const Text(
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

                const SizedBox(height: 15),

                const Text(
                  'Constraints',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // SizedBox(height: 10),
                Text(widget.contestDetails['constraints']),

                const SizedBox(height: 15),
              ],
            ),
          ),
          Container(
            // height: double.infinity,

            child: SplitView(
              // gripSize: 6, // Size of the grip
              controller: _controller,
              viewMode: SplitViewMode.Vertical,
              children: [
                Container(
                  color: const Color(0xff23241f),
                  height: MediaQuery.of(context).size.height * 0.73,
                  child: SingleChildScrollView(
                    child: CodeTheme(
                      data: const CodeThemeData(
                        styles: monokaiSublimeTheme,
                      ),
                      child: CodeField(
                        focusNode: _focusNode,
                        controller: _codeController!,
                        textStyle: const TextStyle(fontFamily: 'SourceCode'),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
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
                                child: const Row(
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
                                      child: const Row(
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
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '$_clickCount / $_maxClicks',
                                    style: const TextStyle(
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
                                  child: const Icon(
                                      Icons.arrow_drop_down_circle_outlined)),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 25,
                        // ),

                        const SizedBox(
                          height: 11,
                        ),
                        Container(
                          color: Colors.black,
                          child: TextField(
                            controller: _inputController,
                            maxLines: 7,
                            style: const TextStyle(color: Colors.white),

                            //   decoration: InputDecoration(
                            //     labelText: 'Input',

                            // ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          'Output',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(
                          height: 11,
                        ),
                        Container(
                          height: 400,
                          width: double.infinity,
                          color: Colors.black,
                          child: Text(
                            output,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                          ),
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
    const serverUrl =
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
    const serverUrl =
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
