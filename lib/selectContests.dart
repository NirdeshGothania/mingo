import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mingo/TablePage.dart';
import 'package:mingo/common_widgets.dart';

class SelectContests extends StatefulWidget {
  const SelectContests({super.key});

  @override
  _SelectContestsState createState() => _SelectContestsState();
}

class _SelectContestsState extends State<SelectContests> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedContestIds = <String>{};
  List<QueryDocumentSnapshot> _allContests = [];
  List<QueryDocumentSnapshot> _displayedContests = [];
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchContests();
  }

  void _fetchContests() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('createContest').get();
    final now = DateTime.now();
    setState(() {
      _allContests = snapshot.docs.where((contest) {
        final contestData = contest.data();
        var et = (contestData['endTime'] as String).split(':');
        var endDateTime = DateFormat('dd-MM-yyyy:HH:mm').parse(
            contestData['endDate'] +
                ':${et[0].padLeft(2, '0')}:${et[1].padLeft(2, '0')}');
        return endDateTime.isBefore(now);
      }).toList();
      _displayedContests = List.from(_allContests);
    });
  }

  void _searchContests() {
    final searchQuery = _searchController.text.toLowerCase();
    final now = DateTime.now();
    setState(() {
      _displayedContests = _allContests.where((contest) {
        final contestData = contest.data() as Map<String, dynamic>;
        final contestName = contestData['contestName'].toString().toLowerCase();
        final matchName = contestName.contains(searchQuery);

        var et = (contestData['endTime'] as String).split(':');
        var endDateTime = DateFormat('dd-MM-yyyy:HH:mm').parse(
            contestData['endDate'] +
                ':${et[0].padLeft(2, '0')}:${et[1].padLeft(2, '0')}');
        var st = (contestData['startTime'] as String).split(':');
        var startDateTime = DateFormat('dd-MM-yyyy:HH:mm').parse(
            contestData['startDate'] +
                ':${st[0].padLeft(2, '0')}:${st[1].padLeft(2, '0')}');

        final matchDate =
            (_startDate == null || startDateTime.isAfter(_startDate!)) &&
                (_endDate == null || endDateTime.isBefore(_endDate!)) &&
                endDateTime.isBefore(now);

        return matchName && matchDate;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _startDate = null;
      _endDate = null;
      _displayedContests = List.from(_allContests);
    });
  }

  void _selectAllContests() {
    setState(() {
      if (_selectedContestIds.length == _displayedContests.length) {
        _selectedContestIds.clear();
      } else {
        _selectedContestIds
          ..clear()
          ..addAll(_displayedContests.map((contest) => contest.id));
      }
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: const Text('Select Contests'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TablePage(selectedContests: _selectedContestIds),
                      ),
                    );
                },
                icon: const Icon(Icons.forward_outlined),
                label: const Text('Proceed')),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _searchController,
                    hintText: 'Contest Name',
                    iconData: Icons.search,
                    onSubmitted: (p0) {
                      _searchContests();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _searchContests,
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _resetFilters,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FilledButton(
                  onPressed: () => _selectStartDate(context),
                  child: Text(_startDate == null
                      ? 'Select Start Date'
                      : 'Start Date: ${DateFormat('dd-MM-yyyy').format(_startDate!)}'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => _selectEndDate(context),
                  child: Text(_endDate == null
                      ? 'Select End Date'
                      : 'End Date: ${DateFormat('dd-MM-yyyy').format(_endDate!)}'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _selectAllContests,
                  icon: const Icon(Icons.select_all),
                  label: const Text('Select All'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _displayedContests.isEmpty
                ? const Center(child: Text('No contests found.'))
                : ListView.builder(
                    itemCount: _displayedContests.length,
                    itemBuilder: (context, index) {
                      final contest = _displayedContests[index];
                      final contestData =
                          contest.data() as Map<String, dynamic>;
                      final contestName = contestData['contestName'];
                      var et = (contestData['endTime'] as String).split(':');
                      var endDateTime = DateFormat('dd-MM-yyyy:HH:mm').parse(
                          contestData['endDate'] +
                              ':${et[0].padLeft(2, '0')}:${et[1].padLeft(2, '0')}');
                      var st = (contestData['startTime'] as String).split(':');
                      var startDateTime = DateFormat('dd-MM-yyyy:HH:mm').parse(
                          contestData['startDate'] +
                              ':${st[0].padLeft(2, '0')}:${st[1].padLeft(2, '0')}');
                      return ListTile(
                        title: Text(
                          contestName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Start Date: ${contestData['startDate']} Start time: ${st[0].padLeft(2, '0')}:${st[1].padLeft(2, '0')}"),
                            Text(
                                "End Date: ${contestData['endDate']} End time: ${et[0].padLeft(2, '0')}:${et[1].padLeft(2, '0')}"),
                          ],
                        ),
                        leading: Checkbox(
                          value: _selectedContestIds.contains(contest.id),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedContestIds.add(contest.id);
                              } else {
                                _selectedContestIds.remove(contest.id);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
