// // class QuillTest extends StatefulWidget {
// //   const QuillTest({super.key});

// //   @override
// //   State<QuillTest> createState() => _QuillTestState();
// // }

// // class _QuillTestState extends State<QuillTest> {
// //   @override
// //   Widget build(BuildContext context) {
// //     var controller1 = QuillController.basic();
// //     var controller2 = QuillController.basic();
// //     return Scaffold(
// //       body: Column(
// //         children: [
// //           QuillToolbar.simple(
// //             configurations: QuillSimpleToolbarConfigurations(
// //               controller: controller1,
// //               sharedConfigurations: const QuillSharedConfigurations(
// //                   // locale: Locale('de'),
// //                   ),
// //             ),
// //           ),
// //           QuillEditor(
// //             configurations: QuillEditorConfigurations(
// //               controller: controller1,
// //               autoFocus: false,
// //               readOnly: false,
// //             ),
// //             scrollController: ScrollController(keepScrollOffset: true),
// //             focusNode: FocusNode(),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               var doc = controller1.document.toDelta().toJson();
// //               print(doc.runtimeType);
// //               controller2.document = Document.fromJson(doc);
// //             },
// //             child: const Text('Press me!'),
// //           ),
// //           QuillEditor(
// //             configurations: QuillEditorConfigurations(
// //               controller: controller2,
// //               autoFocus: false,
// //               readOnly: false,
// //             ),
// //             scrollController: ScrollController(keepScrollOffset: true),
// //             focusNode: FocusNode(),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class Test extends StatefulWidget {
// //   const Test({Key? key}) : super(key: key);

// //   @override
// //   _TestState createState() => _TestState();
// // }

// // class _TestState extends State<Test> {
// //   List<String> selectedContests = [];
// //   late TextEditingController _searchController;
// //   late Stream<QuerySnapshot> _stream;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _searchController = TextEditingController();
// //     _stream =
// //         FirebaseFirestore.instance.collection('createContest').snapshots();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: CustomAppbar(
// //         title: const Text('Admin Page'),
// //         actions: [
// //           IconButton(
// //             onPressed: _showTableViewDialog,
// //             icon: const Icon(Icons.view_list),
// //           ),
// //         ],
// //       ),
// //       body: Center(
// //         child: StreamBuilder<QuerySnapshot>(
// //           stream: _stream,
// //           builder: (context, snapshot) {
// //             if (snapshot.connectionState == ConnectionState.waiting) {
// //               return const CircularProgressIndicator();
// //             }
// //             if (snapshot.hasError) {
// //               return Text('Error: ${snapshot.error}');
// //             }
// //             // Filtering contests based on end date and time
// //             final contests = snapshot.data!.docs.where((contest) {
// //               final contestData = contest.data() as Map<String, dynamic>;
// //               final endDateTime = DateTime.parse(
// //                   contestData['endDate'] + ' ' + contestData['endTime']);
// //               return endDateTime.isAfter(DateTime.now());
// //             }).toList();

// //             // Filtering contests based on search text
// //             final searchText = _searchController.text.toLowerCase();
// //             final filteredContests = contests.where((contest) {
// //               final contestData = contest.data() as Map<String, dynamic>;
// //               final contestName = contestData['contestName'].toLowerCase();
// //               return contestName.contains(searchText);
// //             }).toList();

// //             return ListView.builder(
// //               itemCount: filteredContests.length,
// //               itemBuilder: (context, index) {
// //                 final contest = filteredContests[index];
// //                 final contestData = contest.data() as Map<String, dynamic>;
// //                 final contestName = contestData['contestName'];
// //                 final isSelected = selectedContests.contains(contestName);

// //                 return ListTile(
// //                   title: Text(
// //                     contestName,
// //                     style: const TextStyle(fontWeight: FontWeight.bold),
// //                   ),
// //                   subtitle: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                           "Start Date: ${contestData['startDate']} Start time: ${contestData['startTime']}"),
// //                       Text(
// //                           "End Date: ${contestData['endDate']} End time: ${contestData['endTime']}"),
// //                     ],
// //                   ),
// //                   trailing: Checkbox(
// //                     value: isSelected,
// //                     onChanged: (value) {
// //                       setState(() {
// //                         if (value == true) {
// //                           selectedContests.add(contestName);
// //                         } else {
// //                           selectedContests.remove(contestName);
// //                         }
// //                       });
// //                     },
// //                   ),
// //                 );
// //               },
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   void _showTableViewDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return StatefulBuilder(
// //           builder: (context, setState) {
// //             return AlertDialog(
// //               title: const Text("View Table"),
// //               content: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   TextField(
// //                     controller: _searchController,
// //                     decoration: const InputDecoration(
// //                       labelText: "Search Contest",
// //                       prefixIcon: Icon(Icons.search),
// //                     ),
// //                     onChanged: (value) {
// //                       setState(
// //                           () {}); // Trigger rebuild to update search results
// //                     },
// //                   ),
// //                   const SizedBox(height: 20),
// //                   Expanded(
// //                     child: StreamBuilder<QuerySnapshot>(
// //                       stream: _stream,
// //                       builder: (context, snapshot) {
// //                         if (snapshot.connectionState ==
// //                             ConnectionState.waiting) {
// //                           return const CircularProgressIndicator();
// //                         }
// //                         if (snapshot.hasError) {
// //                           return Text('Error: ${snapshot.error}');
// //                         }
// //                         // Filtering contests based on end date and time
// //                         final contests = snapshot.data!.docs.where((contest) {
// //                           final contestData =
// //                               contest.data() as Map<String, dynamic>;
// //                           final endDateTime = DateTime.parse(
// //                               contestData['endDate'] +
// //                                   ' ' +
// //                                   contestData['endTime']);
// //                           return endDateTime.isAfter(DateTime.now());
// //                         }).toList();

// //                         // Filtering contests based on search text
// //                         final searchText = _searchController.text.toLowerCase();
// //                         final filteredContests = contests.where((contest) {
// //                           final contestData =
// //                               contest.data() as Map<String, dynamic>;
// //                           final contestName =
// //                               contestData['contestName'].toLowerCase();
// //                           return contestName.contains(searchText);
// //                         }).toList();

// //                         return ListView.builder(
// //                           itemCount: filteredContests.length,
// //                           itemBuilder: (context, index) {
// //                             final contest = filteredContests[index];
// //                             final contestData =
// //                                 contest.data() as Map<String, dynamic>;
// //                             final contestName = contestData['contestName'];
// //                             final isSelected =
// //                                 selectedContests.contains(contestName);

// //                             return CheckboxListTile(
// //                               title: Text(contestName),
// //                               value: isSelected,
// //                               onChanged: (value) {
// //                                 setState(() {
// //                                   if (value == true) {
// //                                     selectedContests.add(contestName);
// //                                   } else {
// //                                     selectedContests.remove(contestName);
// //                                   }
// //                                 });
// //                               },
// //                             );
// //                           },
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               actions: [
// //                 TextButton(
// //                   onPressed: () {
// //                     Navigator.of(context).pop();
// //                   },
// //                   child: const Text("Cancel"),
// //                 ),
// //                 TextButton(
// //                   onPressed: () {
// //                     Navigator.of(context).pop(selectedContests);
// //                   },
// //                   child: const Text("Proceed"),
// //                 ),
// //               ],
// //             );
// //           },
// //         );
// //       },
// //     ).then((value) {
// //       // Handle selection result
// //       if (value != null) {
// //         // Navigate to table page with selected contests
// //         // Navigator.push(
// //         //   context,
// //         //   MaterialPageRoute(
// //         //     builder: (context) => TablePage(selectedContests: value),
// //         //   ),
// //         // );
// //       }
// //     });
// //   }
// // }

// import 'dart:collection';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_quill/quill_delta.dart';
// import 'package:intl/intl.dart';
// import 'package:mingo/common_widgets.dart';
// import 'package:mingo/createContest.dart';
// import 'package:mingo/loginPage.dart';
// import 'package:mingo/sessionConstants.dart';
// import 'package:mingo/student_list.dart';

// class Test extends StatefulWidget {
//   const Test({Key? key}) : super(key: key);

//   @override
//   State<Test> createState() => AdminPage();
// }

// class AdminPage extends State<Test> {
//   final _auth = FirebaseAuth.instance;
//   final LinkedHashMap<Delta, dynamic> contestDetails =
//       LinkedHashMap<Delta, dynamic>();
//   var adminName = '';

//   @override
//   void initState() {
//     super.initState();
//     getName();
//   }

//   void getName() async {
//     await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(SessionConstants.email)
//         .get()
//         .then((value) {
//       final nameData = value.data();
//       setState(() {
//         adminName = nameData!['name'];
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppbar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Hi, $adminName',
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Center(
//                     child: FilledButton.icon(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   const CreateContest(contestDetails: null),
//                             ),
//                           );
//                         },
//                         icon: const Icon(Icons.create),
//                         label: const Text('Create Contest'))),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 FilledButton.icon(
//                     onPressed: () {
//                       _auth.signOut();
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const loginPage1(),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.logout),
//                     label: const Text('Sign Out')),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 FilledButton.icon(
//                     onPressed: () {
//                       _showViewTableDialog();
//                     },
//                     icon: const Icon(Icons.table_chart),
//                     label: const Text('View Table')),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: Center(
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('createContest')
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator();
//             }
//             if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             }
//             // var contestDetails;
//             final contests = snapshot.data!.docs;
//             final filteredContests = contests.where((contest) {
//               final contestData = contest.data() as Map<String, dynamic>;
//               return contestData['email'] == SessionConstants.email;
//             }).toList();

//             return ListView.builder(
//               itemCount: filteredContests.length,
//               itemBuilder: (context, index) {
//                 final contest = filteredContests[index];
//                 final contestData = contest.data() as Map<String, dynamic>;
//                 print(contestData);
//                 print(contestData.runtimeType);
//                 final contestName = contestData['contestName'];
//                 var et = (contestData['endTime'] as String).split(':');
//                 var endDateTime = DateFormat('dd-MM-yyyy:hh:mm').parse(
//                     contestData['endDate'] +
//                         ':${et[0].padLeft(2, '0')}:${et[1].padLeft(2, '0')}');
//                 var st = (contestData['startTime'] as String).split(':');
//                 var startDateTime = DateFormat('dd-MM-yyyy:hh:mm').parse(
//                     contestData['startDate'] +
//                         ':${st[0].padLeft(2, '0')}:${st[1].padLeft(2, '0')}');
//                 return ListTile(
//                   title: Text(
//                     contestName,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                             "Start Date: ${contestData['startDate']} Start time: ${contestData['startTime']}"),
//                         Text(
//                             "End Date: ${contestData['endDate']} End time: ${contestData['endTime']}"),
//                       ]), // Add additional information as needed
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize
//                         .min, // Ensure the row takes only the necessary space
//                     children: [
//                       FilledButton.icon(
//                           onPressed: endDateTime.isBefore(DateTime.now())
//                               ? () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => StudentList(
//                                           contestDetails: contestData),
//                                     ),
//                                   );
//                                 }
//                               : null,
//                           icon: const Icon(Icons.remove_red_eye_outlined),
//                           label: const Text('View Contest')),
//                       const SizedBox(width: 8),
//                       FilledButton.icon(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   CreateContest(contestDetails: contestData),
//                             ),
//                           );
//                         },
//                         icon: const Icon(Icons.edit_square),
//                         label: const Text("Edit Contest"),
//                       ),
//                       const SizedBox(width: 8), // Add spacing between buttons
//                       FilledButton.icon(
//                         onPressed: () {
//                           _showDeleteConfirmationDialog(
//                               contestData['contestId']);
//                         },
//                         icon: const Icon(Icons.delete),
//                         label: const Text('Delete'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _showDeleteConfirmationDialog(String? contestId) {
//     if (contestId != null) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text("Confirm Delete"),
//             content:
//                 const Text("Are you sure you want to delete this contest?"),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text("Cancel"),
//               ),
//               TextButton(
//                 onPressed: () {
//                   deleteContest(contestId);
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text("Delete"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   void deleteContest(String? contestId) {
//     FirebaseFirestore.instance
//         .collection('createContest')
//         .doc(contestId)
//         .delete()
//         .then((value) {
//       // Contest deleted successfully
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Contest deleted successfully'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }).catchError((error) {
//       // Error occurred while deleting contest
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error deleting contest: $error'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     });

//     FirebaseFirestore.instance
//         .collection('Contest')
//         .where('contestId', isEqualTo: contestId)
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       if (querySnapshot.docs.isNotEmpty) {
//         String docIdToDelete = querySnapshot.docs.first.id;
//         FirebaseFirestore.instance
//             .collection('Contest')
//             .doc(docIdToDelete)
//             .delete()
//             .then((value) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Question deleted successfully'),
//               backgroundColor: Colors.green,
//             ),
//           );
//           print('Document deleted successfully!');
//         }).catchError((error) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Error deleting contest: $error'),
//               backgroundColor: Colors.red,
//             ),
//           );
//           print('Error deleting document: $error');
//         });
//       } else {
//         print('Document with contestId $contestId not found.');
//       }
//     }).catchError((error) {
//       print('Error querying document: $error');
//     });
//   }

//   void _showViewTableDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return AlertDialog(
//               title: const Text("View Table"),
//               content: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // Add search box and date selectors here
//                     // Replace with your own implementation
//                     // For example:
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: 'Search'),
//                       onChanged: (value) {
//                         // Implement search functionality
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     const Text("Select Date Range:"),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             decoration:
//                                 const InputDecoration(labelText: 'Start Date'),
//                             onTap: () async {
//                               DateTime? pickedDate = await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime(2015, 8),
//                                 lastDate: DateTime(2101),
//                               );
//                               if (pickedDate != null) {
//                                 // Handle selected start date
//                               }
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: TextFormField(
//                             decoration:
//                                 const InputDecoration(labelText: 'End Date'),
//                             onTap: () async {
//                               DateTime? pickedDate = await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime(2015, 8),
//                                 lastDate: DateTime(2101),
//                               );
//                               if (pickedDate != null) {
//                                 // Handle selected end date
//                               }
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     // Proceed button functionality
//                     Navigator.of(context).pop();
//                     // Navigate to TablePage with selected contests
//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //     builder: (context) => TablePage(selectedContests: selectedContests),
//                     //   ),
//                     // );
//                   },
//                   child: const Text('Proceed'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class TablePage extends StatelessWidget {
//   final List<Map<String, dynamic>> selectedContests;

//   const TablePage({Key? key, required this.selectedContests}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Implement the table display with selected contests
//     // Add functionality to download as Excel file
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Table Page'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Implement download functionality
//             },
//             icon: const Icon(Icons.download),
//           ),
//         ],
//       ),
//       body: Container(
//           // Implement table UI here
//           ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContestSelectionDialog extends StatefulWidget {
  const ContestSelectionDialog({super.key});

  @override
  _ContestSelectionDialogState createState() => _ContestSelectionDialogState();
}

class _ContestSelectionDialogState extends State<ContestSelectionDialog> {
  List<String> selectedContests = [];
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Contests"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search Contests',
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('createContest')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final contests = snapshot.data!.docs.where((contest) {
                  final contestData = contest.data() as Map<String, dynamic>;
                  final contestName = contestData['contestName'] as String;
                  return contestName
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                }).toList();

                return SizedBox(
                  height: 300, // Set a fixed height for the ListView
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: contests.length,
                    itemBuilder: (context, index) {
                      final contest = contests[index];
                      final contestData =
                          contest.data() as Map<String, dynamic>;
                      return CheckboxListTile(
                        title: Text(contestData['contestName']),
                        value: selectedContests.contains(contest.id),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedContests.add(contest.id);
                            } else {
                              selectedContests.remove(contest.id);
                            }
                          });
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // navigateToTablePage();
          },
          child: const Text("Proceed"),
        ),
      ],
    );
  }
}

void showViewTableDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const ContestSelectionDialog();
    },
  );
}
