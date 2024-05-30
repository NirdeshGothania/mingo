import 'dart:convert';
import 'dart:html' as html;
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:mingo/FinishContest.dart';
import 'package:mingo/OpenContest.dart';
import 'package:mingo/common_widgets.dart';
import 'package:mingo/sessionConstants.dart';
import 'package:mingo/studentPage.dart';
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
  CodeController? _codeController;
  var output = '';
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  double leftContainerWidth = 150.0;
  final SplitViewController _controller = SplitViewController();
  var submitCount = 3;
  MaterialStatesController? stateControl;
  var _violationActive = false;
  var _isFullScreen = false;
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
  bool _isLoadingRunCode = false;
  bool isLoadingSave = false;
  bool isLoadingSubmit = false;

  @override
  void initState() {
    super.initState();

    SessionConstants.isContestActive = true;

    _focusNode.addListener(_handleFocusChange);

    _controller.weights = [0.73, 0.27];
    Future.delayed(const Duration(milliseconds: 10)).then((value) {
      FullScreenWindow.setFullScreen(true);
    });
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

    html.window.onBlur.listen((html.Event e) {
      if (!SessionConstants.isContestActive) return;
      print("Tab blurred");
      if (!_violationActive) violationWarning();
    });

    const EventStreamProvider<Event>('fullscreenchange')
        .forTarget(html.window)
        .listen((event) {
      if (!SessionConstants.isContestActive) return;
      print('fullscreen changed');
      if (_isFullScreen) {
        if (!_violationActive) violationWarning();
      }
      _isFullScreen = !_isFullScreen;
    });

    html.window.onPageHide.listen((html.Event e) {
      if (!SessionConstants.isContestActive) return;
      print("Tab hidden");
      if (!_violationActive) violationWarning();
    });

    html.document.onVisibilityChange.listen((html.Event e) {
      if (!SessionConstants.isContestActive) return;
      if (html.document.visibilityState == 'hidden') {
        print("Tab switched");
        if (!_violationActive) violationWarning();
      } else if (html.document.visibilityState == 'visible') {
        print("Tab focused");
      }
    });
  }

  void violationWarning() {
    _violationActive = true;
    showDialog(
      barrierDismissible: false,
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
                  'Warning! Violation Detected',
                  style: TextStyle(fontSize: 17),
                ),
                content: const Text(
                  'Continue before the timer ends or you will be debarred from the contest.',
                  style: TextStyle(fontSize: 18),
                ),
                actions: [
                  SizedBox(
                    width: 300,
                    child: TimerCountdown(
                      format: CountDownTimerFormat.secondsOnly,
                      endTime: DateTime.now().add(const Duration(
                        seconds: 5,
                      )),
                      onEnd: () async {
                        await FirebaseFirestore.instance
                            .collection('createContest')
                            .doc(widget.contestDetails!['contestId'])
                            .collection('register')
                            .doc(SessionConstants.email2)
                            .set({
                          'status': -1,
                        }).then((value) async {
                          for (int i = 0;
                              i < widget.contestQuestions.length;
                              i++) {
                            await FirebaseFirestore.instance
                                .collection('createContest')
                                .doc(widget.contestDetails!['contestId'])
                                .collection('register')
                                .doc(SessionConstants.email2)
                                .collection('result')
                                .doc(widget.contestQuestions[i].questionId)
                                .set({
                              'marks': 0,
                              'testCasesPassed': null,
                            });
                          }
                          SessionConstants.isContestActive = false;
                          Navigator.of(context)
                            ..pop()
                            ..pop()
                            ..pop();
                          Future.delayed(const Duration(milliseconds: 10))
                              .then((value) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FinishContest(
                                  contestQuestions: widget.contestQuestions,
                                  contestDetails: widget.contestDetails,
                                ),
                              ),
                            );
                            FullScreenWindow.setFullScreen(false);
                          }).catchError((error) {
                            print('Exit Contest: $error');
                          });
                        });
                      },
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      FullScreenWindow.setFullScreen(true);
                      _violationActive = false;
                      Navigator.of(context).pop();
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xff2b2d7f))),
                    child: const Text('CONTINUE'),
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
  void dispose() {
    super.dispose();
    //
  }

  void endContest() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const StudentPage1()));
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
          'contest_${widget.contestQuestions[i].contestId}/Submissions/question_${widget.contestQuestions[i].questionId}/${SessionConstants.email2!.replaceAll(RegExp('@iiitr.ac.in'), '')}';
      await firebase_storage.FirebaseStorage.instance
          .ref(inputFilePath)
          .putString(widget.contestQuestions[i].code)
          .then((p0) {
        setState(() {
          isLoadingSave = false;
        });
      }).catchError((error) {
        setState(() {
          isLoadingSave = false;
        });
      });
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
                    child: CustomTextField(
                      controller: email,
                      hintText: 'Comment',
                      iconData: Icons.comment,
                    ),
                  ),
                  FilledButton(
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
      appBar: CustomAppbar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Code Arena',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
                FilledButton.icon(
                  onPressed: () {
                    _commentalert();
                  },
                  icon: const Icon(Icons.comment),
                  label: const Text('Comment'),
                ),
                const SizedBox(
                  width: 5,
                ),
                FilledButton.icon(
                  onPressed: () async {
                    SessionConstants.isContestActive = false;
                    await FirebaseFirestore.instance
                        .collection('createContest')
                        .doc(widget.contestDetails!['contestId'])
                        .collection('register')
                        .doc(SessionConstants.email2)
                        .set({
                      'status': 2,
                    }).then((value) {
                      Navigator.of(context)
                        ..pop()
                        ..pop()
                        ..pop();
                      Future.delayed(const Duration(milliseconds: 10))
                          .then((value) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FinishContest(
                              contestQuestions: widget.contestQuestions,
                              contestDetails: widget.contestDetails,
                            ),
                          ),
                        );
                        FullScreenWindow.setFullScreen(false);
                      });
                      print('Entered Contest successfully');
                    }).catchError((error) {
                      print('Entered Contest: $error');
                    });
                  },
                  icon: const Icon(Icons.flag),
                  label: const Text(
                    'End Contest',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
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
                              FilledButton.icon(
                                onPressed: _isLoadingRunCode
                                    ? null
                                    : () {
                                        setState(() {
                                          _isLoadingRunCode = true;
                                        });
                                        _controller.weights = [0.3, 0.7];
                                        final res =
                                            _codeController!.text.toString();
                                        final inp =
                                            _inputController.text.toString();
                                        print(res);
                                        print(inp);
                                        runCode(res, inp);
                                      },
                                icon: _isLoadingRunCode
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.play_arrow),
                                label: _isLoadingRunCode
                                    ? const Text(
                                        'Running...',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : const Text(
                                        'Run',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                              FilledButton.icon(
                                onPressed: isLoadingSave
                                    ? null
                                    : () {
                                        setState(() {
                                          isLoadingSave = true;
                                        });
                                        widget.contestQuestions[quesIndex]
                                                .code =
                                            _codeController!.text.toString();
                                        UploadCodeFiles();
                                      },
                                icon: isLoadingSave
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.save),
                                label: isLoadingSave
                                    ? const Text(
                                        'Saving...',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : const Text('Save'),
                              ),
                              FilledButton.icon(
                                onPressed: isLoadingSubmit
                                    ? null
                                    : () {
                                        isLoadingSubmit = true;
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
                                                .contestId,
                                            SessionConstants.email2!);
                                      },
                                icon: isLoadingSubmit
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.play_arrow),
                                label: isLoadingSubmit
                                    ? const Text(
                                        'Submitting...',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : const Text(
                                        'Submit',
                                        style: TextStyle(
                                            // fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              FilledButton(
                                  onPressed: () {
                                    _controller.weights = [0.73, 0.27];
                                    setState(() {});
                                  },
                                  child: const Icon(
                                      Icons.arrow_drop_down_circle_outlined)),
                            ],
                          ),
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
        '${SessionConstants.host}/runcode'; // Replace with your server URL

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code, 'input': input}),
      );
      output = '';
      output = output + response.body;
      _isLoadingRunCode = false;
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
      setState(() {
        _isLoadingRunCode = false;
      });
      print('Exception: $e');
      // Handle exception and update the UI accordingly
    }
  }

  Future<void> test(String? code, String? questionId, String? contestId,
      String? studentId) async {
    const serverUrl =
        '${SessionConstants.host}/test'; // Replace with your server URL
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'code': code,
          'questionId': questionId,
          'contestId': contestId,
          'studentId': studentId
        }),
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
        setState(() {
          isLoadingSubmit = false;
        });
        // You can handle or process the response body as needed
      } else {
        print('Error: ${response.statusCode}');
        print('Error message: ${response.body}');
        setState(() {
          isLoadingSubmit = false;
        });
        // Handle the error and update the UI accordingly
      }
      setState(() {});
    } catch (e) {
      print('Exception: $e');
      setState(() {
        isLoadingSubmit = false;
      });

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
