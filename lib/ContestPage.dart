import 'dart:async' as io;
import 'dart:html' as html;
import 'dart:io';
// import 'package:mingo/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:mingo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_quill/flutter_quill.dart';
// import 'package:contest/ContestDisplay.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'dart:typed_data';
// import 'package:flutter_cloud_storage/storage_service.dart';

class ContestPage1 extends StatefulWidget {
  final Delta contestName;
  final Delta question;
  final Delta inputFormat;
  final Delta outputFormat;
  final Delta sampleTestCases;
  // final Delta explanation;
  final Delta constraints;

  const ContestPage1({
    Key? key,
    required this.contestName,
    required this.question,
    required this.inputFormat,
    required this.outputFormat,
    required this.sampleTestCases,
    // required this.explanation,
    required this.constraints,
  }) : super(key: key);

  @override
  State<ContestPage1> createState() => ContestPage();
}

class ContestPage extends State<ContestPage1> {
  final _auth = FirebaseAuth.instance;
  late QuillController contestNameController;
  late QuillController _questionController;
  late QuillController _inputFormatController;
  late QuillController _outputFormatController;
  late QuillController _constraintsController;

  List<QuillController> _controllers = [];
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

  // void _addNewQuestion() {
  //   _questionController.add(QuillController.basic());
  //   _inputFormatController.add(QuillController.basic());
  //   _outputFormatController.add(QuillController.basic());
  //   _controllers.add(QuillController.basic());
  //   _controllers.add(QuillController.basic());
  //   _controllers.add(QuillController.basic());
  //   _constraintsController.add(QuillController.basic());

  //   count++; // Incrementing the count when adding new test cases
  // }

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
    _addNewTestCases();
    // _addNewQuestion();
    contestNameController = QuillController(
      document: Document.fromDelta(widget.contestName),
      selection: const TextSelection.collapsed(offset: 0),
    );
    _questionController = QuillController(
      document: Document.fromDelta(widget.question),
      selection: const TextSelection.collapsed(offset: 0),
    );
    _inputFormatController = QuillController(
      document: Document.fromDelta(widget.inputFormat),
      selection: const TextSelection.collapsed(offset: 0),
    );
    _outputFormatController = QuillController(
      document: Document.fromDelta(widget.outputFormat),
      selection: const TextSelection.collapsed(offset: 0),
    );

    _constraintsController = QuillController(
      document: Document.fromDelta(widget.constraints),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  Future<void> uploadFile(Uint8List fileBytes, String fileName) async {
    try {
      await storage.ref('contest_name/$fileName').putData(fileBytes);
      print('File $fileName uploaded successfully.');
    } on FirebaseException catch (e) {
      print('Error uploading file $fileName: $e');
    }
  }

  Future<void> createContest(
      var contestName,
      var question,
      var inputFormat,
      var outputFormat,
      List<Map<String, dynamic>> sampleTestCases,
      var constraints) async {
    final serverUrl = 'https://proj-server.onrender.com/createContest';

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'contestName': contestName.toJson(),
            'question': question.toJson(),
            'inputFormat': inputFormat.toJson(),
            'outputFormat': outputFormat.toJson(),
            'sampleTestCases': sampleTestCases,
            'constraints': constraints.toJson(),
          },
        ),
      );
      print(contestName);
      if (response.statusCode == 200) {
        print('Success!');
        var responseBody = response.body;
        print('Response body: $responseBody');
      } else {
        print('Error: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
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
      appBar: AppBar(
        title: Text('Contest Page'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
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
                title: Text(
                  'Contest Name',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                children: [
                  Container(
                    height: 100,
                    child: TextEditor(
                      controller: contestNameController,
                      hintText: 'Contest Name',
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.0),

            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey)),
              child: ExpansionTile(
                // backgroundColor: Colors.grey.shade100,
                collapsedBackgroundColor: Colors.grey.shade200,
                // controlAffinity: ListTileControlAffinity.leading,

                title: Text(
                  'Problem Statement',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                children: [
                  Container(
                    height: 300,
                    child: TextEditor(
                      controller: _questionController,
                      hintText: 'Question',
                    ),
                  ),
                ],
                initiallyExpanded: true,
              ),
            ),

            SizedBox(height: 16.0),

            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey)),
              child: ExpansionTile(
                initiallyExpanded: true,
                collapsedBackgroundColor: Colors.grey.shade200,
                title: Text(
                  'Input Format',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                children: [
                  Container(
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

            SizedBox(height: 16.0),

            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey)),
              child: ExpansionTile(
                initiallyExpanded: true,
                collapsedBackgroundColor: Colors.grey.shade200,
                title: Text(
                  'Output Format',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                children: [
                  Container(
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

            SizedBox(height: 16.0),

            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey)),
              child: ListView.builder(
                itemCount: count,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpansionTile(
                          initiallyExpanded: true,
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          title: Text(
                            'Sample Test Case ${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                            ),
                          ),
                          children: [
                            Text(
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
                            Text(
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
                            Text(
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
                        SizedBox(height: 10),
                        ElevatedButton(
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
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  _addNewTestCases();
                });
              },
              child: Icon(Icons.add),
            ),

            SizedBox(height: 16.0),

            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey)),
              child: ExpansionTile(
                initiallyExpanded: true,
                collapsedBackgroundColor: Colors.grey.shade200,
                title: Text(
                  'Constraints',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                children: [
                  Container(
                    height: 200,
                    child: TextEditor(
                      controller: _constraintsController,
                      hintText: 'Constraints',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    'Hidden Test Cases',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final hiddenFiles = await FilePicker.platform.pickFiles(
                        allowMultiple: true,
                        type: FileType.custom,
                        allowedExtensions: ['txt'],
                      );
                      if (hiddenFiles == null || hiddenFiles.files.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No file selected!')),
                        );
                        return;
                      }

                      for (final file in hiddenFiles.files) {
                        final bytes = file.bytes;
                        final fileName = file.name;
                        print(fileName);
                        await uploadFile(bytes!, fileName);
                      }
                    },
                    child: Text('Upload Files'),
                  ),
                ],
              ),
            ),

            // SizedBox(height: 16.0),

            SizedBox(height: 16.0),

            Container(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  var contestName = contestNameController.document.toDelta();

                  var question = _questionController.document.toDelta();
                  var inputFormat = _inputFormatController.document.toDelta();
                  var outputFormat = _outputFormatController.document.toDelta();

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

                  var constraints = _constraintsController.document.toDelta();

                  createContest(contestName, question, inputFormat,
                      outputFormat, sampleTestCases, constraints);
                },
                child: Text(
                  'Create Contest',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ),
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
      // child: QuillEditor.basic(
      //   configurations: QuillEditorConfigurations(
      //     controller: controller,
      //   ),
      // ),

      child: Column(
        children: [
          Container(
            color: Colors.grey.shade200,
            width: double.infinity,
            child: QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: controller,
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
