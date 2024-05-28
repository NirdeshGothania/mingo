import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mingo/common_widgets.dart';
import 'package:mingo/contestView.dart';

class StudentList extends StatefulWidget {
  final Map<String, dynamic>? contestDetails;
  const StudentList({super.key, required this.contestDetails});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  List<Map<String, dynamic>> registeredData = [];

  @override
  void initState() {
    super.initState();
    fetchRegisteredStudents();
  }

  Future<void> fetchRegisteredStudents() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('createContest')
          .doc(widget.contestDetails!['contestId'])
          .collection('register')
          .get();

      setState(() {
        registeredData = snapshot.docs.map((doc) {
          var data = doc.data();
          data['docId'] = doc.id;
          return data;
        }).toList();
      });
    } catch (e) {
      print('Error fetching registered students: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: Text('Students Participated')),
      body: registeredData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: registeredData.length,
              itemBuilder: (context, index) {
                var student = registeredData[index];
                return ListTile(
                  title: Text(student['docId'].toString()),
                  trailing: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ContestView(
                                contestDetails: widget.contestDetails,
                                email: student['docId'].toString(),
                              )));
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined),
                    label: const Text('View Solution'),
                  ),
                );
              },
            ),
    );
  }
}
