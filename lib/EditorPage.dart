import 'dart:convert';
import 'dart:html' as html;

import 'package:code_text_field/code_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mingo/registerContest.dart';
import 'package:mingo/sessionConstants.dart';
import 'package:split_view/split_view.dart';

class EditorPage extends StatefulWidget {
  final Map<String, dynamic>? contestDetails;
  final List<ContestQuestion> contestQuestions;
  const EditorPage(
      {super.key,
      required this.contestQuestions,
      required this.contestDetails});

  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
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
  final bool _isFullScreen = false;
  final _comment = TextEditingController();
  var filteredContests;
  int quesIndex = 0;
  late DateTime endDateDateTime;
  late DateTime startDateDateTime;
  late TimeOfDay startTimeDateTime;
  late TimeOfDay endTimeDateTime;
  var contestNameController = QuillController.basic();
  final _questionController = QuillController.basic();
  final _inputFormatController = QuillController.basic();
  final _outputFormatController = QuillController.basic();
  final _constraintsController = QuillController.basic();
  final _sampleTestCasesController = QuillController.basic();
  final FocusNode _focusNodekey = FocusNode();
  var count = 0;

  void _incrementClickCount() {
    _clickCount++;
    if (_clickCount >= _maxClicks) {
      _clickCount = _maxClicks;
    }
  }

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(_handleFocusChange);

    _controller.weights = [0.73, 0.27];
    Future.delayed(const Duration(milliseconds: 10)).then((value) {
      FullScreenWindow.setFullScreen(true);
    });

    html.window.onBlur.listen((html.Event e) {
      print("Tab blurred");
    });

    // html.window.onKeyPress.listen((event) {
    //   //
    // });

    html.window.onFocus.listen((html.Event e) {
      print("Tab coding");
    });

    html.window.onResize.listen((html.Event e) {
      count++;
      print("Tab resized");
    });

    html.window.onKeyPress.listen((event) {
      print('keycode $event pressed from initstate');
    });

    html.window.onPageHide.listen((html.Event e) {
      print("Tab Hide");
    });

    // Add a listener for the visibility change event (when the tab is switched).
    html.document.onVisibilityChange.listen((html.Event e) {
      if (html.document.visibilityState == 'hidden') {
        print("Tab switched");
      }
      if (html.document.visibilityState == 'visible') {
        print("Tab Focussed");
      }
    });

    // fetchCodeFiles();

    _codeController = CodeController(
      text: widget.contestQuestions[quesIndex].code,
      language: cpp,
    );

    endDateDateTime =
        DateFormat('dd-MM-yyyy').parse(widget.contestDetails!['endDate']);
    startDateDateTime =
        DateFormat('dd-MM-yyyy').parse(widget.contestDetails!['startDate']);
    startTimeDateTime = TimeOfDay.fromDateTime(
        DateFormat('HH:mm').parse(widget.contestDetails!['startTime']));
    endTimeDateTime = TimeOfDay.fromDateTime(
        DateFormat('HH:mm').parse(widget.contestDetails!['endTime']));
    setController(0);
    // _focusNodekey.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    //
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

  void setController(int newIndex) {
    contestNameController.document =
        Document.fromDelta(widget.contestQuestions[newIndex].contestName);
    _questionController.document =
        Document.fromDelta(widget.contestQuestions[newIndex].question);
    _inputFormatController.document =
        Document.fromDelta(widget.contestQuestions[newIndex].inputFormat);
    _outputFormatController.document =
        Document.fromDelta(widget.contestQuestions[newIndex].outputFormat);
    _constraintsController.document =
        Document.fromDelta(widget.contestQuestions[newIndex].constraints);

    var delta = Delta();
    int idx = 1;
    for (var testCase in widget.contestQuestions[newIndex].sampleTestCases) {
      delta.insert("\nTest Case $idx\n", {'bold': true});
      delta.insert("Input\n", {'bold': true});
      delta.insert(Document.fromDelta(testCase.input).toPlainText(), {
        'code': true,
      });
      delta.insert("Output\n", {'bold': true});
      delta.insert(Document.fromDelta(testCase.output).toPlainText(), {
        'code': true,
      });
      delta.insert("Explanation\n", {'bold': true});
      delta = delta.concat(testCase.explanation);
      idx++;
    }
    _sampleTestCasesController.document = Document.fromDelta(delta);
  }

  void UploadCodeFiles() async {
    for (int i = 0; i < widget.contestQuestions.length; i++) {
      String inputFilePath =
          'contest_${widget.contestQuestions[i].contestId}/Submissions/question_${widget.contestQuestions[i].questionId}/${sessionConstants.email2!.replaceAll(RegExp('@iiitr.ac.in'), '')}';
      await firebase_storage.FirebaseStorage.instance
          .ref(inputFilePath)
          .putString(widget.contestQuestions[i].code);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: const Text(
          'Code Arena',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff2b2d7f),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TimerCountdown(
                  timeTextStyle: const TextStyle(color: Colors.white),
                  descriptionTextStyle:
                      const TextStyle(color: Colors.white, fontSize: 8),
                  colonsTextStyle: const TextStyle(color: Colors.white),
                  format: CountDownTimerFormat.daysHoursMinutesSeconds,
                  endTime: DateTime.now().add(Duration(
                    days: endDateDateTime.isAfter(DateTime.now())
                        ? endDateDateTime.day - DateTime.now().day
                        : 0,
                    hours: endTimeDateTime.hour - TimeOfDay.now().hour,
                    minutes: endTimeDateTime.minute - TimeOfDay.now().minute,
                    seconds: 0,
                  )),
                  onEnd: () {
                    setState(() {});
                  },
                ),
                const SizedBox(
                  width: 50,
                ),
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
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Text(
                        'Submit Contest',
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
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Questions:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.contestQuestions.length,
                  padding: const EdgeInsets.all(10.0),
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: FilledButton(
                        onPressed: (quesIndex == index)
                            ? null
                            : () {
                                widget.contestQuestions[quesIndex].code =
                                    _codeController!.text.toString();
                                quesIndex = index;
                                _codeController = CodeController(
                                  text: widget.contestQuestions[quesIndex].code,
                                  language: cpp,
                                );
                                setController(quesIndex);

                                setState(() {});
                                Navigator.pop(context);
                              },
                        child: Text(
                          Document.fromDelta(
                                  widget.contestQuestions[index].contestName)
                              .toPlainText()
                              .trim(),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      body: KeyboardListener(
        focusNode: _focusNodekey,
        onKeyEvent: (KeyEvent event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.escape ||
                event.logicalKey == LogicalKeyboardKey.f11) {
              // Preventing default action by not doing anything
              print(
                  'Prevented default action for ${event.logicalKey.keyLabel}');
            }
          }
        },
        child: SplitView(
          viewMode: SplitViewMode.Horizontal,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextEditor(controller: contestNameController),
                  const SizedBox(height: 15),
                  const Text(
                    'Problem Statement',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextEditor(controller: _questionController),
                  const SizedBox(height: 15),
                  const Text(
                    'Input Format',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextEditor(controller: _inputFormatController),
                  const SizedBox(height: 15),
                  const Text(
                    'Output Format',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextEditor(controller: _outputFormatController),
                  const SizedBox(height: 15),
                  const Text(
                    'Sample Test Cases',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextEditor(controller: _sampleTestCasesController),
                  const SizedBox(height: 15),
                  const Text(
                    'Constraints',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextEditor(controller: _constraintsController),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            Container(
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
                          // focusNode: _focusNode,
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
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _controller.weights = [0.3, 0.7];
                                    setState(() {});
                                    final res =
                                        _codeController!.text.toString();
                                    final inp =
                                        _inputController.text.toString();
                                    print(res);
                                    print(inp);
                                    runCode(res, inp);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.pink,
                                  ),
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    size: 20,
                                  ),
                                  label: const Text(
                                    'Run',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              FilledButton(
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color(0xff2b2d7f))),
                                onPressed: () {
                                  widget.contestQuestions[quesIndex].code =
                                      _codeController!.text.toString();
                                  UploadCodeFiles();
                                },
                                child: const Text('Save'),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: 150,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _controller.weights = [0.3, 0.8];
                                          setState(() {});
                                          final res =
                                              _codeController?.text.toString();
                                          // print(res);
                                          widget.contestQuestions[quesIndex]
                                              .code = res!;

                                          UploadCodeFiles();
                                          test(
                                              res,
                                              widget.contestQuestions[quesIndex]
                                                  .questionId,
                                              widget.contestQuestions[quesIndex]
                                                  .contestId, sessionConstants.email2!);
                                        },

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
                                    // Text(
                                    //   '$_clickCount / $_maxClicks',
                                    //   style: const TextStyle(
                                    //       fontSize: 11, color: Colors.grey),
                                    // ),
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
      ),
    );
    // setState(() {});
  }

  Future<void> runCode(String? code, String input) async {
    const serverUrl =
        '${sessionConstants.host}/runcode'; // Replace with your server URL

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
            'Success!'); // replace this with your desired success handling logic

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
  }

  Future<void> test(String? code, String? questionId, String? contestId, String? studentId) async {
    const serverUrl =
        '${sessionConstants.host}/test'; // Replace with your server URL
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'code': code, 'questionId': questionId, 'contestId': contestId, 'studentId': studentId}),
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
  }
}

class TextEditor extends StatelessWidget {
  final QuillController controller;

  const TextEditor({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillEditor(
          configurations: QuillEditorConfigurations(
              controller: controller,
              autoFocus: false,
              readOnly: true,
              showCursor: false,
              customStyles:
                  const DefaultStyles(sizeLarge: TextStyle(fontSize: 25))),
          // controller: widget.controller,
          scrollController: ScrollController(keepScrollOffset: true),
          // autoFocus: false,

          focusNode: FocusNode(),
          // placeholder: widget.hintText,
        ),
      ],
    );
  }
}
