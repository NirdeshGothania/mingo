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
  Map<String, String> names = {};

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

      List<Map<String, dynamic>> fetchedData = snapshot.docs.map((doc) {
        var data = doc.data();
        data['docId'] = doc.id;
        return data;
      }).toList();

      for (var student in fetchedData) {
        fetchName(student['docId'].toString());
      }

      setState(() {
        registeredData = fetchedData;
      });
    } catch (e) {
      print('Error fetching registered students: $e');
    }
  }

  Future<void> fetchName(String email) async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('Users').doc(email).get();
      setState(() {
        names[email] = snapshot.data()?['name'] ?? 'Unknown';
      });
    } catch (e) {
      print('Error fetching name for $email: $e');
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
                var email = student['docId'].toString();
                var studentName = names[email] ?? 'Loading...';

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(studentName),
                    ],
                  ),
                  subtitle: Text(email),
                  trailing: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ContestView(
                                contestDetails: widget.contestDetails,
                                email: email,
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
