import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:http/http.dart' as http;
import 'package:mingo/common_widgets.dart';

class ContestView extends StatefulWidget {
  final Map<String, dynamic>? contestDetails;
  final String? email;
  const ContestView(
      {super.key, required this.contestDetails, required this.email});

  @override
  State<ContestView> createState() => _ContestViewState();
}

class _ContestViewState extends State<ContestView> {
  List<ContestQuestion2> contestQuestions = [];
  Map<String, Map<String, dynamic>> resultDetailsMap = {};
  int quesIndex = 0;
  CodeController? _codeController;
  bool isLoading = true;
  var contestNameController = QuillController.basic();
  final _questionController = QuillController.basic();
  final _inputFormatController = QuillController.basic();
  final _outputFormatController = QuillController.basic();
  final _constraintsController = QuillController.basic();
  final _sampleTestCasesController = QuillController.basic();

  Future<void> fetchData() async {
    final contests =
        await FirebaseFirestore.instance.collection('Contest').get();
    final results = await FirebaseFirestore.instance
        .collection('createContest')
        .doc(widget.contestDetails!['contestId'])
        .collection('register')
        .doc(widget.email)
        .collection('result')
        .get();

    contestQuestions = contests.docs.where((contest) {
      final contestData = contest.data();
      return contestData['contestId'] == widget.contestDetails!['contestId'];
    }).map((e) {
      var q = e.data();
      return ContestQuestion2(
        questionId: q['questionId'],
        contestId: q['contestId'],
        contestName: Delta.fromJson(q['contestName']),
        question: Delta.fromJson(q['question']),
        inputFormat: Delta.fromJson(q['inputFormat']),
        outputFormat: Delta.fromJson(q['outputFormat']),
        sampleTestCases: (q['sampleTestCases'] as List<dynamic>)
            .map((e) => SampleTestCase(
                  input: Delta.fromJson(e['input']),
                  output: Delta.fromJson(e['output']),
                  explanation: Delta.fromJson(e['explanation']),
                ))
            .toList(),
        constraints: Delta.fromJson(q['constraints']),
        code: q['code'] ??
            '#include<stdio.h>    \nint main() {\n    printf("Hello, world!");\n    return 0;\n}',
      );
    }).toList();

    resultDetailsMap = {
      for (var doc in results.docs) doc.id: doc.data(),
    };

    await fetchCodeFiles();

    if (contestQuestions.isNotEmpty) {
      setController(0); // Set the controller after fetching the code files
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchCodeFiles() async {
    for (int i = 0; i < contestQuestions.length; i++) {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('contest_${contestQuestions[i].contestId}')
          .child('/Submissions')
          .child('/question_${contestQuestions[i].questionId}')
          .child('/${widget.email!.replaceAll(RegExp('@iiitr.ac.in'), '')}');
      try {
        final downloadUrl = await ref.getDownloadURL();
        String newCodeFile = await http.read(Uri.parse(downloadUrl));
        contestQuestions[i].code = newCodeFile;
      } catch (error) {
        print('Error fetching code download URL: $error');
        // Handle network or other client-side errors here (e.g., display error message)
      }
    }
  }

  void setController(int newIndex) {
    contestNameController.document =
        Document.fromDelta(contestQuestions[newIndex].contestName);
    _questionController.document =
        Document.fromDelta(contestQuestions[newIndex].question);
    _inputFormatController.document =
        Document.fromDelta(contestQuestions[newIndex].inputFormat);
    _outputFormatController.document =
        Document.fromDelta(contestQuestions[newIndex].outputFormat);
    _constraintsController.document =
        Document.fromDelta(contestQuestions[newIndex].constraints);

    var delta = Delta();
    int idx = 1;
    for (var testCase in contestQuestions[newIndex].sampleTestCases) {
      delta.insert("\nTest Case $idx\n", {'bold': true});
      delta.insert("Input\n", {'bold': true});
      delta.insert(
          Document.fromDelta(testCase.input).toPlainText(), {'code': true});
      delta.insert("Output\n", {'bold': true});
      delta.insert(
          Document.fromDelta(testCase.output).toPlainText(), {'code': true});
      delta.insert("Explanation\n", {'bold': true});
      delta = delta.concat(testCase.explanation);
      idx++;
    }
    _sampleTestCasesController.document = Document.fromDelta(delta);

    setState(() {
      quesIndex = newIndex;
      _codeController = CodeController(
        text: contestQuestions[quesIndex].code,
        language: cpp,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: Text('View Contest'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.contestDetails!['contestName'],
                          style: const TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Questions: ',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: contestQuestions.length,
                          itemBuilder: (context, index) {
                            var resultDetails = resultDetailsMap[
                                contestQuestions[index].questionId];
                            return ListTile(
                              title: FilledButton(
                                onPressed: () {
                                  setController(index);
                                },
                                child: Text(Document.fromDelta(
                                        contestQuestions[index].contestName)
                                    .toPlainText()
                                    .trim()),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                      'Marks achieved: ${resultDetails?['marks'] ?? 'N/A'}'),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                      'Number of testcases passed: ${resultDetails?['testCasesPassed']?.length ?? 0}')
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextEditor(controller: contestNameController),
                              const SizedBox(height: 15),
                              const Text(
                                'Problem Statement',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextEditor(controller: _questionController),
                              const SizedBox(height: 15),
                              const Text(
                                'Input Format',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextEditor(controller: _inputFormatController),
                              const SizedBox(height: 15),
                              const Text(
                                'Output Format',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextEditor(controller: _outputFormatController),
                              const SizedBox(height: 15),
                              const Text(
                                'Sample Test Cases',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextEditor(
                                  controller: _sampleTestCasesController),
                              const SizedBox(height: 15),
                              const Text(
                                'Constraints',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextEditor(controller: _constraintsController),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      if (_codeController != null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CodeTheme(
                              data: const CodeThemeData(
                                styles: monokaiSublimeTheme,
                              ),
                              child: CodeField(
                                controller: _codeController!,
                                textStyle:
                                    const TextStyle(fontFamily: 'SourceCode'),
                                readOnly: true,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class SampleTestCase {
  final Delta input;
  final Delta output;
  final Delta explanation;

  const SampleTestCase({
    required this.input,
    required this.output,
    required this.explanation,
  });
}

class ContestQuestion2 {
  final String questionId;
  final String contestId;
  final Delta contestName;
  final Delta question;
  final Delta inputFormat;
  final Delta outputFormat;
  final List<SampleTestCase> sampleTestCases;
  final Delta constraints;
  String code;

  ContestQuestion2({
    required this.questionId,
    required this.contestId,
    required this.contestName,
    required this.question,
    required this.inputFormat,
    required this.outputFormat,
    required this.sampleTestCases,
    required this.constraints,
    required this.code,
  });
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
                const DefaultStyles(sizeLarge: TextStyle(fontSize: 25)),
          ),
          scrollController: ScrollController(keepScrollOffset: true),
          focusNode: FocusNode(),
        ),
      ],
    );
  }
}
