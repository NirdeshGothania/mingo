import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuillTest extends StatefulWidget {
  const QuillTest({super.key});

  @override
  State<QuillTest> createState() => _QuillTestState();
}

class _QuillTestState extends State<QuillTest> {
  @override
  Widget build(BuildContext context) {
    var controller1 = QuillController.basic();
    var controller2 = QuillController.basic();
    return Scaffold(
      body: Column(
        children: [
          QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
              controller: controller1,
              sharedConfigurations: const QuillSharedConfigurations(
                  // locale: Locale('de'),
                  ),
            ),
          ),
          QuillEditor(
            configurations: QuillEditorConfigurations(
              controller: controller1,
              autoFocus: false,
              readOnly: false,
            ),
            scrollController: ScrollController(keepScrollOffset: true),
            focusNode: FocusNode(),
          ),
          ElevatedButton(
            onPressed: () {
              var doc = controller1.document.toDelta().toJson();
              print(doc.runtimeType);
              controller2.document = Document.fromJson(doc);
            },
            child: const Text('Press me!'),
          ),
          QuillEditor(
            configurations: QuillEditorConfigurations(
              controller: controller2,
              autoFocus: false,
              readOnly: false,
            ),
            scrollController: ScrollController(keepScrollOffset: true),
            focusNode: FocusNode(),
          ),
        ],
      ),
    );
  }
}
