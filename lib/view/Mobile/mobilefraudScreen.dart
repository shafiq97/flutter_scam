import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraudrader/view/Mobile/addphonefraud.dart';
import 'package:fraudrader/view/Mobile/phonedetailscreen.dart';

class MobileFraudScreen extends StatefulWidget {
  final User user;
  const MobileFraudScreen({super.key, required this.user});

  @override
  State<MobileFraudScreen> createState() => _MobileFraudScreenState();
}

class _MobileFraudScreenState extends State<MobileFraudScreen> {
  final CollectionReference _fraudsCollection =
      FirebaseFirestore.instance.collection('mobile');
  late List<Map<String, dynamic>> _allFrauds;
  late List<Map<String, dynamic>> _filteredFrauds;
  final TextEditingController _searchController = TextEditingController();
  int _fraudCount = 0;
  String _dangerInfo = '';
  int _searchCount = 0;

  @override
  void initState() {
    super.initState();
    _allFrauds = [];
    _filteredFrauds = [];
    _fetchFrauds();
  }

  void onFraudAdded() {
    _fetchFrauds();
  }

  Future<void> _updateSearchCount(String searchText) async {
    DocumentReference searchRef =
        FirebaseFirestore.instance.collection('searchCounts').doc(searchText);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(searchRef);

          if (!snapshot.exists) {
            transaction.set(searchRef, {'count': 1});
          } else {
            // Cast the data to a Map<String, dynamic>
            Map<String, dynamic> data =
                snapshot.data() as Map<String, dynamic>? ?? {};
            int currentCount = data['count'] ?? 0;
            transaction.update(searchRef, {'count': currentCount + 1});
          }
        })
        .then((value) => print("Search Count Updated"))
        .catchError((error) => print("Failed to update search count: $error"));
  }

  Future<int> _getSearchCount(String searchText) async {
    DocumentReference searchRef =
        FirebaseFirestore.instance.collection('searchCounts').doc(searchText);

    DocumentSnapshot snapshot = await searchRef.get();
    if (snapshot.exists) {
      // Cast the data to a Map<String, dynamic>
      Map<String, dynamic> data =
          snapshot.data() as Map<String, dynamic>? ?? {};
      return data['count'] ?? 0;
    }
    return 0;
  }

  Future<void> _fetchFrauds() async {
    final snapshot = await _fraudsCollection.get();
    final frauds = snapshot.docs.map((doc) {
      return {
        'documentId': doc.id, // Store the document ID
        ...doc.data() as Map<String, dynamic>, // Spread the existing data
      };
    }).toList();
    setState(() {
      _allFrauds = frauds;
      _filteredFrauds = frauds;
    });
  }

  void _filterFrauds(String query) async {
    final filteredFrauds = _allFrauds.where((group) {
      final fraudName = group['firstName'] ?? '';
      final fraudDescription = group['phoneNumber'] ?? '';
      return fraudName.toLowerCase().contains(query.toLowerCase()) ||
          fraudDescription.toLowerCase().contains(query.toLowerCase());
    }).toList();
    int searchCount = await _getSearchCount(query);

    setState(() {
      _filteredFrauds = filteredFrauds;
      _fraudCount = filteredFrauds.length;
      _searchCount = searchCount; // New state variable to hold search count
      log(_filteredFrauds.toString());
    });
    if (_fraudCount > 0) {
      _dangerInfo =
          'WARNING: $_fraudCount reports found for this number! Searched $_searchCount times.';
    } else {
      _dangerInfo = 'No report found, searched $_searchCount times';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              // Add Row to place TextField and IconButton in one line
              children: [
                Expanded(
                  // Wrap TextField with Expanded
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search by Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _filterFrauds(_searchController.text);
                    _updateSearchCount(_searchController.text);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredFrauds.length,
              itemBuilder: (BuildContext context, int index) {
                final fraud = _filteredFrauds[index];
                final fraudName = fraud['firstName'] ?? '';
                final fraudPhoneNumber = fraud['phoneNumber'] ?? '';

                return Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          const Text(
                            "Name - ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            fraudName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          const Text("Phone - "),
                          Text(
                            fraudPhoneNumber,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PhoneDetailScreen(
                              desc: fraud['description'],
                              fraudName: fraudName,
                              images: fraud['images'],
                              WalletName: fraud['WalletName'],
                              transactionID: fraud['transactionID'],
                              phoneNumber: fraud['phoneNumber'],
                            ),
                          ),
                        );
                      },
                      trailing:
                          widget.user.email == 'muhammadshafiq457@gmail.com'
                              ? IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmation(
                                        context,
                                        fraud[
                                            'documentId']); // Pass the document ID to the method
                                  },
                                )
                              : null,
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
          if (_dangerInfo.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Text(
                _dangerInfo,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(
            height: 50.0,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PhoneFraud(
                    user: widget.user,
                    onFraudAdded: onFraudAdded, // Pass the callback here
                  )));
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, String documentId) async {
    final confirmDelete = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete this item?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context)
                      .pop(false), // Dismiss and return false
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () => Navigator.of(context)
                      .pop(true), // Dismiss and return true
                ),
              ],
            );
          },
        ) ??
        false; // if dialog is dismissed by tapping outside, treat as 'Cancel'

    if (confirmDelete) {
      // If confirmed, delete the document
      await _fraudsCollection.doc(documentId).delete();
      // Update the UI
      _fetchFrauds();
    }
  }
}
