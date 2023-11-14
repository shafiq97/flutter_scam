import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraudrader/view/Mobile/addphonefraud.dart';
import 'package:fraudrader/view/Mobile/phonedetailscreen.dart';

class MobileFraudScreen extends StatefulWidget {
  User user;
  MobileFraudScreen({required this.user});

  @override
  _MobileFraudScreenState createState() => _MobileFraudScreenState();
}

class _MobileFraudScreenState extends State<MobileFraudScreen> {
  final CollectionReference _fraudsCollection =
      FirebaseFirestore.instance.collection('mobile');
  late List<Map<String, dynamic>> _allFrauds;
  late List<Map<String, dynamic>> _filteredFrauds;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allFrauds = [];
    _filteredFrauds = [];
    _fetchFrauds();
  }

  Future<void> _fetchFrauds() async {
    final snapshot = await _fraudsCollection.get();
    final frauds =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    setState(() {
      _allFrauds = frauds;
      _filteredFrauds = frauds;
    });
  }

  void _filterFrauds(String query) {
    final filteredFrauds = _allFrauds.where((group) {
      final fraudName = group['firstName'] ?? '';
      final fraudDescription = group['phoneNumber'] ?? '';
      return fraudName.toLowerCase().contains(query.toLowerCase()) ||
          fraudDescription.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredFrauds = filteredFrauds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Phone Number',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterFrauds,
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
                          Text("Name - ",style: TextStyle(fontSize: 15),),
                          Text(fraudName,style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Text("Phone - "),
                          Text(fraudPhoneNumber,style: TextStyle(fontWeight: FontWeight.bold),),
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
                    ),
                    Divider()
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PhoneFraud(user: widget.user,)));
        },
      ),
    );
  }
}
