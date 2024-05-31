// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class TablePage extends StatelessWidget {
//   final List<Map<String, dynamic>> selectedContests;

//   const TablePage({super.key, required this.selectedContests});

//   Future<List<Map<String, dynamic>>> fetchStudentData() async {
//     List<Map<String, dynamic>> students = [];
//     for (var contest in selectedContests) {
//       final results = await FirebaseFirestore.instance
//           .collection('createContest')
//           .doc(contest['contestId'])
//           .collection('register')
//           .get();
//       for (var result in results.docs) {
//         final studentData = result.data();
//         students.add({
//           'name': studentData['name'],
//           'rollNumber': studentData['rollNumber'],
//           'contestId': contest['contestId'],
//           'marks': studentData['marks'] ?? 'N/A',
//           'status': studentData['status'],
//         });
//       }
//     }
//     return students;
//   }

//   Future<void> createExcelFile(List<Map<String, dynamic>> students) async {
//     var excel = Excel.createExcel();
//     Sheet sheet = excel['Sheet1'];

//     // Header
//     List<String> headers = ['Sr No.', 'Name', 'Roll Number'];
//     headers.addAll(selectedContests.map((contest) => contest['contestName']));
//     sheet.appendRow(headers);

//     // Data rows
//     int srNo = 1;
//     for (var student in students) {
//       List<String> row = [
//         srNo.toString(),
//         student['name'],
//         student['rollNumber']
//       ];
//       for (var contest in selectedContests) {
//         if (student['contestId'] == contest['contestId']) {
//           String statusText;
//           switch (student['status']) {
//             case 2:
//               statusText = student['marks'].toString();
//               break;
//             case 0:
//               statusText = 'Registered';
//               break;
//             case 1:
//               statusText = 'Entered';
//               break;
//             case -1:
//               statusText = 'Violated';
//               break;
//             default:
//               statusText = 'Not Attended';
//           }
//           row.add(statusText);
//         } else {
//           row.add('Not Applicable');
//         }
//       }
//       sheet.appendRow(row);
//       srNo++;
//     }

//     var fileBytes = excel.save();
//     var dir = await getApplicationDocumentsDirectory();
//     var file = File('${dir.path}/StudentData.xlsx');
//     await file.writeAsBytes(fileBytes!, flush: true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Student Table'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.download),
//             onPressed: () async {
//               List<Map<String, dynamic>> studentData = await fetchStudentData();
//               await createExcelFile(studentData);
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchStudentData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           List<Map<String, dynamic>> students = snapshot.data ?? [];
//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columns: [
//                 const DataColumn(label: Text('Sr No.')),
//                 const DataColumn(label: Text('Name')),
//                 const DataColumn(label: Text('Roll Number')),
//                 for (var contest in selectedContests)
//                   DataColumn(label: Text(contest['contestName'])),
//               ],
//               rows: students.asMap().entries.map((entry) {
//                 int index = entry.key;
//                 Map<String, dynamic> student = entry.value;
//                 return DataRow(cells: [
//                   DataCell(Text((index + 1).toString())),
//                   DataCell(Text(student['name'])),
//                   DataCell(Text(student['rollNumber'])),
//                   for (var contest in selectedContests)
//                     DataCell(Text(student['contestId'] == contest['contestId']
//                         ? student['marks'].toString()
//                         : 'N/A')),
//                 ]);
//               }).toList(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:excel/excel.dart';
// import 'package:path_provider/path_provider.dart';

// class TablePage extends StatelessWidget {
//   final List<Map<String, dynamic>> selectedContests;

//   const TablePage({super.key, required this.selectedContests});

//   Future<List<Map<String, dynamic>>> fetchStudentData() async {
//     List<Map<String, dynamic>> students = [];
//     for (var contest in selectedContests) {
//       final results = await FirebaseFirestore.instance
//           .collection('createContest')
//           .doc(contest['contestId'])
//           .collection('register')
//           .get();
//       for (var result in results.docs) {
//         final studentData = result.data();
//         students.add({
//           'name': studentData['name'],
//           'rollNumber': studentData['rollNumber'],
//           'contestId': contest['contestId'],
//           'marks': studentData['marks'] ?? 'N/A',
//           'status': studentData['status'],
//         });
//       }
//     }
//     return students;
//   }

//   String getStatusText(int status) {
//     switch (status) {
//       case 2:
//         return 'Marks Assigned';
//       case 0:
//         return 'Registered';
//       case 1:
//         return 'Entered';
//       case -1:
//         return 'Violated';
//       default:
//         return 'Not Attended';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Student Table'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.download),
//             onPressed: () async {
//               var excel = Excel.createExcel();
//               Sheet sheet = excel['Sheet1'];

//               // Header
//               List<String> headers = ['Sr No.', 'Name', 'Roll Number'];
//               headers.addAll(selectedContests.map((contest) => contest['contestName']));
//               sheet.appendRow(headers);

//               List<Map<String, dynamic>> studentData = await fetchStudentData();
//               int srNo = 1;

//               for (var student in studentData) {
//                 List<String> row = [srNo.toString(), student['name'], student['rollNumber']];
//                 for (var contest in selectedContests) {
//                   var contestData = studentData.firstWhere(
//                     (element) => element['contestId'] == contest['contestId'] && 
//                                  element['rollNumber'] == student['rollNumber'],
//                     orElse: () => {},
//                   );
//                   if (contestData.isNotEmpty) {
//                     row.add(getStatusText(contestData['status']));
//                   } else {
//                     row.add('Not Attended');
//                   }
//                 }
//                 sheet.appendRow(row);
//                 srNo++;
//               }

//               var fileBytes = excel.save();
//               // Implement the download functionality here, save fileBytes to a file

//               // Example: Save to a file (you need to add permission to access the file storage)
//               final directory = await getExternalStorageDirectory();
//               final path = "${directory?.path}/students.xlsx";
//               final file = File(path);
//               await file.writeAsBytes(fileBytes!);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('File saved to $path')),
//               );
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchStudentData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           List<Map<String, dynamic>> students = snapshot.data ?? [];
//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columns: [
//                 DataColumn(label: Text('Sr No.')),
//                 DataColumn(label: Text('Name')),
//                 DataColumn(label: Text('Roll Number')),
//                 for (var contest in selectedContests) DataColumn(label: Text(contest['contestName'])),
//               ],
//               rows: students.asMap().entries.map((entry) {
//                 int index = entry.key;
//                 Map<String, dynamic> student = entry.value;
//                 return DataRow(cells: [
//                   DataCell(Text((index + 1).toString())),
//                   DataCell(Text(student['name'])),
//                   DataCell(Text(student['rollNumber'])),
//                   for (var contest in selectedContests)
//                     DataCell(Text(getStatusText(student['status']))),
//                 ]);
//               }).toList(),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'dart:typed_data';
// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'package:mingo/common_widgets.dart';
// import 'package:mingo/file_save_helper.dart';

// class TablePage extends StatelessWidget {
//   final List<String> selectedContests;

//   const TablePage({Key? key, required this.selectedContests}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Table Page'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               _exportToExcel(context);
//             },
//             icon: const Icon(Icons.download),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Text('Table Page Content'),
//       ),
//     );
//   }

//   void _exportToExcel(BuildContext context) {
//     // Create Excel workbook and sheet
//     final excel = Excel.createExcel();
//     final sheet = excel['Sheet1'];

//     // Add column headers
//     sheet.appendRow(['Sr No.', 'Name', 'Roll Number', 'Contest Names']);

//     // Add data rows (example data)
//     sheet.appendRow([1, 'John Doe', '12345', 'Contest A, Contest B']);
//     sheet.appendRow([2, 'Jane Doe', '54321', 'Contest B']);
//     sheet.appendRow([3, 'Alice Smith', '98765', 'Contest A, Contest C']);

//     // Encode Excel data
//     final excelData = excel.encode();

//     // Save Excel file
//     _saveExcelFile(context, excelData, 'table.xlsx');
//   }

//   void _saveExcelFile(BuildContext context, Uint8List excelData, String fileName) {
//     // Save file to device
//     FileSaveHelper.saveAndLaunchFile(excelData, fileName);
//   }
// }

