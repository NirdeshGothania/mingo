import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mingo/common_widgets.dart';

class TablePage extends StatefulWidget {
  final Set<String> selectedContests;

  const TablePage({Key? key, required this.selectedContests}) : super(key: key);

  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  List<Map<String, dynamic>> _studentsData = [];
  Map<String, String> _contestNames = {};

  @override
  void initState() {
    super.initState();
    _fetchContestNames();
  }

  Future<void> _fetchContestNames() async {
    final contestNames = <String, String>{};

    for (var contestId in widget.selectedContests) {
      final contestDoc = await FirebaseFirestore.instance
          .collection('createContest')
          .doc(contestId)
          .get();

      if (contestDoc.exists) {
        final contestData = contestDoc.data() as Map<String, dynamic>;
        contestNames[contestId] =
            contestData['contestName'] ?? 'Unknown Contest';
      } else {
        contestNames[contestId] = 'Unknown Contest';
      }
    }

    setState(() {
      _contestNames = contestNames;
    });

    _fetchStudentsData();
  }

  Future<void> _fetchStudentsData() async {
    final studentsSnapshot =
        await FirebaseFirestore.instance.collection('Users').get();
    final List<Map<String, dynamic>> studentsData = [];

    for (var student in studentsSnapshot.docs) {
      final studentData = student.data();
      final studentEmail = student.id;
      final studentContests = await _fetchStudentContests(studentEmail);

      // Check if the student is registered in any contest
      final isRegisteredInAnyContest =
          studentContests.values.any((contest) => contest['status'] != null);

      if (isRegisteredInAnyContest) {
        studentsData.add({
          'name': studentData['name'] ?? 'Unknown',
          'rollnumber': studentData['rollnumber'] ?? 'Unknown',
          'contests': studentContests,
          'totalMarks': studentContests.values.fold<int>(0, (sum, contest) {
            if (contest['status'] == 2) {
              return sum + (contest['marks'] as int? ?? 0);
            }
            return sum;
          }),
        });
      }
    }

    setState(() {
      _studentsData = studentsData;
    });
  }

  Future<Map<String, dynamic>> _fetchStudentContests(String email) async {
    final Map<String, dynamic> contestData = {};

    for (var contestId in widget.selectedContests) {
      final contestDoc = await FirebaseFirestore.instance
          .collection('createContest')
          .doc(contestId)
          .collection('register')
          .doc(email)
          .get();

      if (contestDoc.exists) {
        final status = contestDoc.data()?['status'];
        if (status == 2) {
          final result = await FirebaseFirestore.instance
              .collection('createContest')
              .doc(contestId)
              .collection('register')
              .doc(email)
              .collection('result')
              .get();

          contestData[contestId] = {
            'status': status,
            'marks': result.docs.isNotEmpty
                ? (result.docs.first.data()['marks'] as int? ?? 0)
                : 0,
          };
        } else {
          contestData[contestId] = {
            'status': status,
            'marks': 0,
          };
        }
      } else {
        contestData[contestId] = {
          'status': null,
          'marks': 0,
        };
      }
    }

    return contestData;
  }

  Widget _buildStatusCell(dynamic contest) {
    if (contest == null || contest['status'] == null) {
      return const Text('Not Registered');
    }
    switch (contest['status']) {
      case -1:
        return const Text('Violated');
      case 0:
      case 1:
        return const Text('Not Submitted');
      case 2:
        return Text('Marks: ${contest['marks'] ?? 'N/A'}');
      default:
        return const Text('Unknown');
    }
  }

  void _exportToCSV() {
    final content = StringBuffer();

    // Add header row
    content.writeln(
        'Sr. No.,Name,Roll Number,${widget.selectedContests.map((contestId) => _contestNames[contestId] ?? 'Unknown Contest').join(',')},Total Marks');

    // Add student data
    for (int i = 0; i < _studentsData.length; i++) {
      final student = _studentsData[i];
      content.writeln([
        (i + 1).toString(),
        student['name'] ?? 'Unknown',
        student['rollnumber'] ?? 'Unknown',
        ...widget.selectedContests.map((contestId) {
          final contest = student['contests'][contestId];
          if (contest == null || contest['status'] == null) {
            return 'Not Registered';
          }
          switch (contest['status']) {
            case -1:
              return 'Violated';
            case 0:
            case 1:
              return 'Not Submitted';
            case 2:
              return 'Marks: ${contest['marks'] ?? 'N/A'}';
            default:
              return 'Unknown';
          }
        }),
        student['totalMarks'].toString(),
      ].join(','));
    }

    final blob = html.Blob([content.toString()], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'StudentContestData.csv')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: const Text('Student Contest Participation'),
        actions: [
          FilledButton.icon(
            icon: const Icon(Icons.download),
            onPressed: _studentsData.isEmpty ? null : _exportToCSV,
            label: const Text('Export'),
          ),
        ],
      ),
      body: _studentsData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  const DataColumn(
                      label: Text(
                    'Sr. No.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  const DataColumn(
                      label: Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  const DataColumn(
                      label: Text(
                    'Roll Number',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  ...widget.selectedContests.map((contestId) => DataColumn(
                          label: Text(
                        _contestNames[contestId] ?? 'Unknown Contest',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ))),
                  const DataColumn(label: Text('Total Marks')),
                ],
                rows: List<DataRow>.generate(
                  _studentsData.length,
                  (index) {
                    final student = _studentsData[index];
                    return DataRow(
                      cells: [
                        DataCell(Text((index + 1).toString())),
                        DataCell(Text(student['name'] ?? 'Unknown')),
                        DataCell(Text(student['rollnumber'] ?? 'Unknown')),
                        ...widget.selectedContests.map((contestId) => DataCell(
                            _buildStatusCell(student['contests'][contestId]))),
                        DataCell(Text(student['totalMarks'].toString())),
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }
}
