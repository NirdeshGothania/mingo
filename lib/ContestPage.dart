import 'dart:convert';
import 'dart:typed_data';

// import 'package:mingo/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
// import 'package:contest/ContestDisplay.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mingo/addQuestionPage.dart';
import 'package:mingo/common_widgets.dart';
import 'package:mingo/sessionConstants.dart';
import 'package:uuid/uuid.dart';
// import 'package:flutter_cloud_storage/storage_service.dart';

class ContestPage1 extends StatefulWidget {
  final dynamic questionId;
  final dynamic contestId;
  final dynamic contestName;
  final dynamic question;
  final dynamic inputFormat;
  final dynamic outputFormat;
  final List<dynamic> sampleTestCases;
  final dynamic hiddenTestCases;
  // final dynamic explanation;
  final dynamic constraints;

  const ContestPage1({
    Key? key,
    required this.questionId,
    required this.contestId,
    required this.contestName,
    required this.question,
    required this.inputFormat,
    required this.outputFormat,
    required this.sampleTestCases,
    required this.hiddenTestCases,
    // required this.explanation,
    required this.constraints,
  }) : super(key: key);

  @override
  State<ContestPage1> createState() => ContestPage();
}

class ContestPage extends State<ContestPage1> {
  final _auth = FirebaseAuth.instance;
  var contestNameController = QuillController.basic();
  final _questionController = QuillController.basic();
  final _inputFormatController = QuillController.basic();
  final _outputFormatController = QuillController.basic();
  final _constraintsController = QuillController.basic();
  var marks = TextEditingController();
  List<dynamic> hiddenTestCases = [];
  // var questionid = const Uuid().v4().toString();
  late String questionid;
  // List cleanOps = [];

  late final List<QuillController> _controllers = [];

  var hiddenTestCase = <Map<String, String>>[];

  var label = '';
  var count = 0;

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  void _addNewTestCases() {
    _controllers.add(QuillController.basic());
    _controllers.add(QuillController.basic());
    _controllers.add(QuillController.basic());
    count++; // Incrementing the count when adding new test cases
  }

  void _removeTestCases() {
    if (_controllers.length >= 3) {
      // Ensuring at least one set of test cases remains
      _controllers.removeLast();
      _controllers.removeLast();
      _controllers.removeLast();
      count--; // Decrementing the count when removing test cases
    }
  }

  @override
  void initState() {
    super.initState();

    questionid = widget.questionId == ''
        ? const Uuid().v4().toString()
        : widget.questionId;

    contestNameController.document = Document.fromJson(widget.contestName);
    _questionController.document = Document.fromJson(widget.question);
    _inputFormatController.document = Document.fromJson(widget.inputFormat);
    _outputFormatController.document = Document.fromJson(widget.outputFormat);
    _constraintsController.document = Document.fromJson(widget.constraints);
    print(widget.sampleTestCases);
    count = widget.sampleTestCases.length;
    for (var testCase in widget.sampleTestCases) {
      _controllers.add(QuillController.basic()
        ..document = Document.fromJson(testCase['input']));
      _controllers.add(QuillController.basic()
        ..document = Document.fromJson(testCase['output']));
      _controllers.add(QuillController.basic()
        ..document = Document.fromJson(testCase['explanation']));
    }

    print('hidden: ${widget.hiddenTestCases.runtimeType}');
    hiddenTestCases = widget.hiddenTestCases;
    print('passed');
  }

  Delta removeNewlines(Delta delta) {
    Delta cleanedDelta = Delta();

    var ops = delta.toList();
    for (var i = 0; i < ops.length; i++) {
      var op = ops[i];
      if (op.data is String) {
        var cleanText = (op.data as String).replaceAll('\n', '');
        cleanedDelta = cleanedDelta.concat(Delta()..insert(cleanText));
        if (i == ops.length - 1) {
          if (!(op.data as String).endsWith('\n')) {
            cleanedDelta = cleanedDelta.concat(Delta()..insert('\n'));
          }
        }
      } else if (op.data is Map<String, dynamic>) {
        cleanedDelta = cleanedDelta.concat(Delta()..insert(op.data));
      }
    }

    return cleanedDelta;
  }

  Future<void> uploadFile(Uint8List fileBytes, String filePath) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(filePath)
          .putData(fileBytes);
      print('File $filePath uploaded successfully.');
    } on firebase_storage.FirebaseException catch (e) {
      print('Error uploading file $filePath: $e');
    }
  }

  Future<void> createContest(
      var contestId,
      var questionid,
      var contestName,
      var question,
      var inputFormat,
      var outputFormat,
      List<Map<String, dynamic>> sampleTestCases,
      List<Map<String, dynamic>> hiddenTestCases,
      var constraints) async {
    const serverUrl = '${SessionConstants.host}/createContest';

    http
        .post(
      Uri.parse(serverUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          'contestId': contestId,
          'questionId': questionid,
          'contestName': contestName,
          'question': question,
          'inputFormat': inputFormat,
          'outputFormat': outputFormat,
          'sampleTestCases': sampleTestCases,
          'hiddenTestCases': hiddenTestCases,
          'constraints': constraints,
        },
      ),
    )
        .then((response) {
      print(contestName);
      if (response.statusCode == 200) {
        print('Success!');
        var responseBody = response.body;
        print('Response body: $responseBody');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => addQuestionPage1(
              contestId: contestId,
            ),
          ),
        );
      } else {
        print('Error: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    }).onError((error, stackTrace) {
      print(error);
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Create Question',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 200,
              child: FilledButton.icon(
                onPressed: () async {
                  var contestId = widget.contestId;

                  var contestName =
                      contestNameController.document.toDelta().toJson();

                  var question =
                      _questionController.document.toDelta().toJson();
                  var inputFormat =
                      _inputFormatController.document.toDelta().toJson();
                  var outputFormat =
                      _outputFormatController.document.toDelta().toJson();

                  List<Map<String, dynamic>> sampleTestCases = [];
                  for (var i = 0; i < _controllers.length; i += 3) {
                    if (i + 2 < _controllers.length) {
                      // Ensure all elements exist
                      Map<String, dynamic> testCase = {
                        'input': _controllers[i].document.toDelta().toJson(),
                        'output':
                            _controllers[i + 1].document.toDelta().toJson(),
                        'explanation':
                            _controllers[i + 2].document.toDelta().toJson(),
                      };
                      sampleTestCases.add(testCase);
                    }
                  }

                  List<Map<String, dynamic>> hiddenTestCasesList = [];
                  for (var i = 0; i < hiddenTestCases.length; i++) {
                    String inputFilePath =
                        'contest_$contestId/question_$questionid/testcase${i + 1}/input.txt';
                    String outputFilePath =
                        'contest_$contestId/question_$questionid/testcase${i + 1}/output.txt';

                    // Construct hidden test case data
                    Map<String, dynamic> hiddentestCase = {
                      'inputFilePath': inputFilePath.toString(),
                      'outputFilePath': outputFilePath.toString(),
                      'marks': hiddenTestCases[i]['marks'],
                    };
                    hiddenTestCasesList.add(hiddentestCase);
                  }

                  print(hiddenTestCasesList);

                  var constraints =
                      _constraintsController.document.toDelta().toJson();

                  createContest(
                      contestId,
                      questionid,
                      contestName,
                      question,
                      inputFormat,
                      outputFormat,
                      sampleTestCases,
                      hiddenTestCasesList,
                      constraints);
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  'Add/Save Question',
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey)),
              child: ExpansionTile(
                initiallyExpanded: true,
                collapsedBackgroundColor: Colors.grey.shade200,
                title: const Text(
                  'Question Title',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                children: [
                  SizedBox(
                    height: 100,
                    child: TextEditor(
                      controller: contestNameController,
                      hintText: 'Contest Name',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16.0),

            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey)),
              child: ExpansionTile(
                // backgroundColor: Colors.grey.shade100,
                collapsedBackgroundColor: Colors.grey.shade200,
                // controlAffinity: ListTileControlAffinity.leading,

                title: const Text(
                  'Problem Statement',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                initiallyExpanded: true,
                children: [
                  SizedBox(
                    height: 300,
                    child: TextEditor(
                      controller: _questionController,
                      hintText: 'Question',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16.0),

            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey)),
              child: ExpansionTile(
                initiallyExpanded: true,
                collapsedBackgroundColor: Colors.grey.shade200,
                title: const Text(
                  'Input Format',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                children: [
                  SizedBox(
                    height: 200,
                    child: TextEditor(
                      controller: _inputFormatController,
                      hintText: 'Input Format',
                    ),
                  ),
                ],
              ),
            ),

            // SizedBox(height: 16.0),

            const SizedBox(height: 16.0),

            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey)),
              child: ExpansionTile(
                initiallyExpanded: true,
                collapsedBackgroundColor: Colors.grey.shade200,
                title: const Text(
                  'Output Format',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                children: [
                  SizedBox(
                    height: 200,
                    child: TextEditor(
                      controller: _outputFormatController,
                      hintText: 'Output Format',
                    ),
                  ),
                ],
              ),
            ),

            // SizedBox(height: 16.0),

            const SizedBox(height: 16.0),

            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey)),
              child: ListView.builder(
                itemCount: count,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpansionTile(
                          initiallyExpanded: true,
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          title: Text(
                            'Sample Test Case ${index + 1}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          children: [
                            const Text(
                              'Input',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19),
                            ),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.grey.shade200,
                                    width: double.infinity,
                                    child: QuillToolbar.simple(
                                      configurations:
                                          QuillSimpleToolbarConfigurations(
                                        showSubscript: false,
                                        showSuperscript: false,
                                        controller: _controllers[index * 3],
                                        sharedConfigurations:
                                            const QuillSharedConfigurations(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: QuillEditor(
                                      configurations: QuillEditorConfigurations(
                                        controller: _controllers[index * 3],
                                        autoFocus: false,
                                        readOnly: false,
                                      ),
                                      scrollController: ScrollController(
                                          keepScrollOffset: true),
                                      focusNode: FocusNode(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'Output',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19),
                            ),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.grey.shade200,
                                    width: double.infinity,
                                    child: QuillToolbar.simple(
                                      configurations:
                                          QuillSimpleToolbarConfigurations(
                                        showSubscript: false,
                                        showSuperscript: false,
                                        controller: _controllers[index * 3 + 1],
                                        sharedConfigurations:
                                            const QuillSharedConfigurations(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: QuillEditor(
                                      configurations: QuillEditorConfigurations(
                                        controller: _controllers[index * 3 + 1],
                                        autoFocus: false,
                                        readOnly: false,
                                      ),
                                      scrollController: ScrollController(
                                          keepScrollOffset: true),
                                      focusNode: FocusNode(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'Explanation',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19),
                            ),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.grey.shade200,
                                    width: double.infinity,
                                    child: QuillToolbar.simple(
                                      configurations:
                                          QuillSimpleToolbarConfigurations(
                                        showSubscript: false,
                                        showSuperscript: false,
                                        controller: _controllers[index * 3 + 2],
                                        sharedConfigurations:
                                            const QuillSharedConfigurations(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: QuillEditor(
                                      configurations: QuillEditorConfigurations(
                                        controller: _controllers[index * 3 + 2],
                                        autoFocus: false,
                                        readOnly: false,
                                      ),
                                      scrollController: ScrollController(
                                          keepScrollOffset: true),
                                      focusNode: FocusNode(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              var x = _controllers.length;
                              if ((index + 1) > 3 || ((x) >= 6)) {
                                print(index);
                                print(x);
                                _removeTestCases();
                              }
                            });
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete Sample Test Case'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _addNewTestCases();
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Sample Test Case'),
            ),

            const SizedBox(height: 16.0),

            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey)),
              child: ExpansionTile(
                initiallyExpanded: true,
                collapsedBackgroundColor: Colors.grey.shade200,
                title: const Text(
                  'Constraints',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                children: [
                  SizedBox(
                    height: 200,
                    child: TextEditor(
                      controller: _constraintsController,
                      hintText: 'Constraints',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),

            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.grey),
              ),
              child: ListView.builder(
                itemCount: hiddenTestCases.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var testCase = hiddenTestCases[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hidden Test Case ${index + 1}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            FilledButton.icon(
                              onPressed: () async {
                                final input =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['txt'],
                                );

                                if (input == null || input.files.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('No file selected!')),
                                  );
                                  return;
                                }

                                var inputBytes = input.files.first.bytes;

                                // Upload input file to Firebase Storage
                                String inputFilePath =
                                    'contest_${widget.contestId}/question_$questionid/testcase${index + 1}/input.txt';
                                await uploadFile(inputBytes!, inputFilePath);

                                // Save input file path to testCaseData
                                var testCaseData = {
                                  'inputFilePath': inputFilePath,
                                  'outputFilePath': testCase[
                                      'outputFilePath'], // Keep existing output file path
                                  'marks': testCase['marks'],
                                };

                                setState(() {
                                  hiddenTestCases[index] = testCaseData;
                                });
                              },
                              icon: const Icon(Icons.upload),
                              label: const Text('Upload Input File'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: () async {
                                final output =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['txt'],
                                );

                                if (output == null || output.files.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('No file selected!')),
                                  );
                                  return;
                                }

                                var outputBytes = output.files.first.bytes;

                                // Upload output file to Firebase Storage
                                String outputFilePath =
                                    'contest_${widget.contestId}/question_$questionid/testcase${index + 1}/output.txt';
                                await uploadFile(outputBytes!, outputFilePath);

                                // Save output file path to testCaseData
                                var testCaseData = {
                                  'inputFilePath': testCase[
                                      'inputFilePath'], // Keep existing input file path
                                  'outputFilePath': outputFilePath,
                                  'marks': testCase['marks'],
                                };

                                setState(() {
                                  hiddenTestCases[index] = testCaseData;
                                });
                              },
                              icon: const Icon(Icons.upload),
                              label: const Text('Upload Output File'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          hintText: 'Marks',
                          iconData: Icons.score_outlined,
                          controller: TextEditingController(
                              text: testCase['marks'] ?? ''),
                          onChanged: (value) {
                            testCase['marks'] = value;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              hiddenTestCases.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete Hidden Test Case'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            FilledButton.icon(
              onPressed: () {
                setState(() {
                  hiddenTestCases.add({'marks': ''});
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Hidden Test Case'),
            ),

            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class TextEditor extends StatelessWidget {
  final QuillController controller;
  final String hintText;

  const TextEditor({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade200,
            width: double.infinity,
            child: QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: controller,
                showSubscript: false,
                showSuperscript: false,
                sharedConfigurations: const QuillSharedConfigurations(
                    // locale: Locale('de'),
                    ),
              ),
            ),
          ),
          QuillEditor(
            configurations: QuillEditorConfigurations(
              controller: controller,
              autoFocus: false,
              readOnly: false,
            ),
            // controller: widget.controller,
            scrollController: ScrollController(keepScrollOffset: true),
            // autoFocus: false,

            focusNode: FocusNode(),
            // placeholder: widget.hintText,
          ),
        ],
      ),
    );
  }
}
