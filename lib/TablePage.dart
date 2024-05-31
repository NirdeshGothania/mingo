// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mingo/common_widgets.dart';

// class TablePage extends StatefulWidget {
//   final Set<String> selectedContests;
//   const TablePage({super.key, required this.selectedContests});

//   @override
//   _TablePageState createState() => _TablePageState();
// }

// class _TablePageState extends State<TablePage> {
//   List<Map<String, dynamic>> _studentsData = [];
//   Map<String, String> _contestNames = {};

//   @override
//   void initState() {
//     super.initState();
//     _fetchContestNames();
//   }

//   Future<void> _fetchContestNames() async {
//     final contestNames = <String, String>{};

//     for (var contestId in widget.selectedContests) {
//       final contestDoc = await FirebaseFirestore.instance
//           .collection('createContest')
//           .doc(contestId)
//           .get();

//       if (contestDoc.exists) {
//         final contestData = contestDoc.data();
//         contestNames[contestId] =
//             contestData?['contestName'] ?? 'Unknown Contest';
//       } else {
//         contestNames[contestId] = 'Unknown Contest';
//       }
//     }

//     setState(() {
//       _contestNames = contestNames;
//     });

//     _fetchStudentsData();
//   }

//   Future<void> _fetchStudentsData() async {
//     final studentsSnapshot =
//         await FirebaseFirestore.instance.collection('Users').get();
//     final List<Map<String, dynamic>> studentsData = [];

//     for (var student in studentsSnapshot.docs) {
//       final studentData = student.data();
//       final studentEmail = student.id;
//       final studentContests = await _fetchStudentContests(studentEmail);

//       // Check if the student is registered in any contest
//       final isRegisteredInAnyContest =
//           studentContests.values.any((contest) => contest['status'] != null);

//       if (isRegisteredInAnyContest) {
//         studentsData.add({
//           'name': studentData['name'] ?? 'Unknown',
//           'rollnumber': studentData['rollnumber'] ?? 'Unknown',
//           'contests': studentContests,
//         });
//       }
//     }

//     setState(() {
//       _studentsData = studentsData;
//     });
//   }

//   Future<Map<String, dynamic>> _fetchStudentContests(String email) async {
//     final Map<String, dynamic> contestData = {};

//     for (var contestId in widget.selectedContests) {
//       final contestDoc = await FirebaseFirestore.instance
//           .collection('createContest')
//           .doc(contestId)
//           .collection('register')
//           .doc(email)
//           .get();

//       if (contestDoc.exists) {
//         final status = contestDoc.data()?['status'];
//         if (status == 2) {
//           final result = await FirebaseFirestore.instance
//               .collection('createContest')
//               .doc(contestId)
//               .collection('register')
//               .doc(email)
//               .collection('result')
//               .get();

//           contestData[contestId] = {
//             'status': status,
//             'marks': result.docs.isNotEmpty
//                 ? result.docs.first.data()['marks']
//                 : 'N/A',
//           };
//         } else {
//           contestData[contestId] = {
//             'status': status,
//             'marks': null,
//           };
//         }
//       } else {
//         contestData[contestId] = {
//           'status': null,
//           'marks': null,
//         };
//       }
//     }

//     return contestData;
//   }

//   Widget _buildStatusCell(dynamic contest) {
//     if (contest == null || contest['status'] == null) {
//       return const Text('Not Registered');
//     }
//     switch (contest['status']) {
//       case -1:
//         return const Text('Violated');
//       case 0:
//       case 1:
//         return const Text('Not Submitted');
//       case 2:
//         return Text('Marks: ${contest['marks'] ?? 'N/A'}');
//       default:
//         return const Text('Unknown');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppbar(
//         title: Text('Student Contest Participation'),
//       ),
//       body: _studentsData.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: [
//                   const DataColumn(label: Text('Sr. No.')),
//                   const DataColumn(label: Text('Name')),
//                   const DataColumn(label: Text('Roll Number')),
//                   ...widget.selectedContests.map((contestId) => DataColumn(
//                       label:
//                           Text(_contestNames[contestId] ?? 'Unknown Contest'))),
//                 ],
//                 rows: List<DataRow>.generate(
//                   _studentsData.length,
//                   (index) {
//                     final student = _studentsData[index];
//                     return DataRow(
//                       cells: [
//                         DataCell(Text((index + 1).toString())),
//                         DataCell(Text(student['name'] ?? 'Unknown')),
//                         DataCell(Text(student['rollnumber'] ?? 'Unknown')),
//                         ...widget.selectedContests.map((contestId) => DataCell(
//                             _buildStatusCell(student['contests'][contestId]))),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:mingo/common_widgets.dart';
import 'package:path_provider/path_provider.dart';

class TablePage extends StatefulWidget {
  final Set<String> selectedContests;
  const TablePage({super.key, required this.selectedContests});

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
        final contestData = contestDoc.data();
        contestNames[contestId] =
            contestData?['contestName'] ?? 'Unknown Contest';
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
                ? result.docs.first.data()['marks']
                : 'N/A',
          };
        } else {
          contestData[contestId] = {
            'status': status,
            'marks': null,
          };
        }
      } else {
        contestData[contestId] = {
          'status': null,
          'marks': null,
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

  Future<void> _exportToExcel() async {
    var excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Add header row
    sheet.appendRow([
      'Sr. No.',
      'Name',
      'Roll Number',
      ...widget.selectedContests
          .map((contestId) => _contestNames[contestId] ?? 'Unknown Contest'),
    ]);

    // Add student data
    for (int i = 0; i < _studentsData.length; i++) {
      final student = _studentsData[i];
      sheet.appendRow([
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
      ]);
    }

    // Get the documents directory path
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/StudentContestData.xlsx';
    final fileBytes = excel.encode();
    final file = File(filePath);

    // Write the file
    await file.writeAsBytes(fileBytes!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Excel file exported to $filePath')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: const Text('Student Contest Participation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _studentsData.isEmpty ? null : _exportToExcel,
          ),
        ],
      ),
      body: _studentsData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  const DataColumn(label: Text('Sr. No.')),
                  const DataColumn(label: Text('Name')),
                  const DataColumn(label: Text('Roll Number')),
                  ...widget.selectedContests.map((contestId) => DataColumn(
                      label:
                          Text(_contestNames[contestId] ?? 'Unknown Contest'))),
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
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }
}
