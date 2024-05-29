// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mingo/common_widgets.dart';
// import 'package:mingo/contestView.dart';

// class StudentList extends StatefulWidget {
//   final Map<String, dynamic>? contestDetails;
//   const StudentList({super.key, required this.contestDetails});

//   @override
//   State<StudentList> createState() => _StudentListState();
// }

// class _StudentListState extends State<StudentList> {
//   List<Map<String, dynamic>> registeredData = [];
//   Map<String, String> names = {};
//   Map<String, int> statuses = {};
//   bool showViolationsOnly = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchRegisteredStudents();
//   }

//   Future<void> fetchRegisteredStudents() async {
//     try {
//       var snapshot = await FirebaseFirestore.instance
//           .collection('createContest')
//           .doc(widget.contestDetails!['contestId'])
//           .collection('register')
//           .get();

//       List<Map<String, dynamic>> fetchedData = snapshot.docs.map((doc) {
//         var data = doc.data();
//         data['docId'] = doc.id;
//         return data;
//       }).toList();

//       for (var student in fetchedData) {
//         var email = student['docId'].toString();
//         fetchName(email);
//         fetchStatus(email);
//       }

//       setState(() {
//         registeredData = fetchedData;
//       });
//     } catch (e) {
//       print('Error fetching registered students: $e');
//     }
//   }

//   Future<void> fetchStatus(String email) async {
//     try {
//       var snapshot = await FirebaseFirestore.instance
//           .collection('createContest')
//           .doc(widget.contestDetails!['contestId'])
//           .collection('register')
//           .doc(email)
//           .get();

//       var fetchedStatus = snapshot.data()?['status'] as int?;

//       setState(() {
//         statuses[email] = fetchedStatus ?? 0;
//       });
//     } catch (e) {
//       print('Error fetching status for $email: $e');
//     }
//   }

//   Future<void> fetchName(String email) async {
//     try {
//       var snapshot =
//           await FirebaseFirestore.instance.collection('Users').doc(email).get();
//       setState(() {
//         names[email] = snapshot.data()?['name'] ?? 'Unknown';
//       });
//     } catch (e) {
//       print('Error fetching name for $email: $e');
//     }
//   }

//   String getStatusText(int status) {
//     switch (status) {
//       case -1:
//         return 'Violated';
//       case 2:
//         return 'Submitted';
//       case 1:
//       case 0:
//         return 'Registered';
//       default:
//         return 'Unknown';
//     }
//   }

//   TextStyle getStatusTextStyle(int status) {
//     switch (status) {
//       case -1:
//         return const TextStyle(
//           color: Colors.red,
//           fontWeight: FontWeight.bold,
//         );
//       case 2:
//         return const TextStyle(
//           color: Colors.green,
//           fontWeight: FontWeight.bold,
//         );
//       default:
//         return const TextStyle();
//     }
//   }

//   void toggleViolationView() {
//     setState(() {
//       showViolationsOnly = !showViolationsOnly;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> displayedData = showViolationsOnly
//         ? registeredData
//             .where((student) => statuses[student['docId']] == -1)
//             .toList()
//         : registeredData;

//     return Scaffold(
//       appBar: CustomAppbar(
//         title: const Text('Students Participated'),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: FilledButton.icon(
//               icon: const Icon(Icons.warning),
//               onPressed: toggleViolationView,
//               label: const Text('Violations'),
//             ),
//           ),
//         ],
//       ),
//       body: displayedData.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: displayedData.length,
//               itemBuilder: (context, index) {
//                 var student = displayedData[index];
//                 var email = student['docId'].toString();
//                 var studentName = names[email] ?? 'Loading...';
//                 var studentStatus = statuses[email] ?? 0;
//                 var statusText = getStatusText(studentStatus);
//                 var statusTextStyle = getStatusTextStyle(studentStatus);

//                 return ListTile(
//                   title: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(studentName),
//                     ],
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(email),
//                       Text(
//                         'Status: $statusText',
//                         style: statusTextStyle,
//                       ),
//                     ],
//                   ),
//                   trailing: FilledButton.icon(
//                     onPressed: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => ContestView(
//                                 contestDetails: widget.contestDetails,
//                                 email: email,
//                               )));
//                     },
//                     icon: const Icon(Icons.remove_red_eye_outlined),
//                     label: const Text('View Solution'),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

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
  Map<String, int> statuses = {};
  bool showViolationsOnly = false;

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
        var email = student['docId'].toString();
        fetchName(email);
        fetchStatus(email);
      }

      setState(() {
        registeredData = fetchedData;
      });
    } catch (e) {
      print('Error fetching registered students: $e');
    }
  }

  Future<void> fetchStatus(String email) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('createContest')
          .doc(widget.contestDetails!['contestId'])
          .collection('register')
          .doc(email)
          .get();

      var fetchedStatus = snapshot.data()?['status'] as int?;

      setState(() {
        statuses[email] = fetchedStatus ?? 0;
      });
    } catch (e) {
      print('Error fetching status for $email: $e');
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

  String getStatusText(int status) {
    switch (status) {
      case -1:
        return 'Violated';
      case 2:
        return 'Submitted';
      case 1:
      case 0:
        return 'Registered';
      default:
        return 'Unknown';
    }
  }

  TextStyle getStatusTextStyle(int status) {
    switch (status) {
      case -1:
        return const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        );
      case 2:
        return const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        );
      default:
        return const TextStyle();
    }
  }

  void toggleViolationView() {
    setState(() {
      showViolationsOnly = !showViolationsOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> displayedData = showViolationsOnly
        ? registeredData
            .where((student) => statuses[student['docId']] == -1)
            .toList()
        : registeredData;

    return Scaffold(
      appBar: CustomAppbar(
        title: const Text('Students Participated'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton.icon(
              icon: Icon(showViolationsOnly ? Icons.list : Icons.warning),
              onPressed: toggleViolationView,
              label: showViolationsOnly
                  ? const Text('Show All')
                  : const Text('Violations'),
            ),
          ),
        ],
      ),
      body: displayedData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: displayedData.length,
              itemBuilder: (context, index) {
                var student = displayedData[index];
                var email = student['docId'].toString();
                var studentName = names[email] ?? 'Loading...';
                var studentStatus = statuses[email] ?? 0;
                var statusText = getStatusText(studentStatus);
                var statusTextStyle = getStatusTextStyle(studentStatus);

                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(studentName),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(email),
                      Row(
                        children: [
                          const Text(
                            'Status: ',
                          ),
                          Text(
                            statusText,
                            style: statusTextStyle,
                          )
                        ],
                      ),
                    ],
                  ),
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
