import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fraudrader/view/Bank/addbankfraud.dart';
import 'package:fraudrader/view/Bank/bankDetailScreen.dart';

class BankFraudScreen extends StatefulWidget {
  User user;
  BankFraudScreen({required this.user});
  @override
  _BankFraudScreenState createState() => _BankFraudScreenState();
}

class _BankFraudScreenState extends State<BankFraudScreen> {
  final CollectionReference _fraudsCollection =
      FirebaseFirestore.instance.collection('bank');
  late List<Map<String, dynamic>> _allFrauds;
  late List<Map<String, dynamic>> _filteredFrauds;
  TextEditingController _searchController = TextEditingController();
  int _fraudCount = 0;
  String _dangerInfo = '';
  @override
  void initState() {
    super.initState();
    _allFrauds = [];
    _filteredFrauds = [];
    _fetchFrauds();
  }

  Future<void> _fetchFrauds() async {
    final snapshot = await _fraudsCollection.get();
    final fraudsDetails =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    setState(() {
      _allFrauds = fraudsDetails;
      _filteredFrauds = fraudsDetails;
    });
  }

  void _filterFrauds(String query) {
    final filteredGroups = _allFrauds.where((group) {
      final fraudAccountNumber = group['accountNumber'] ?? '';
      return fraudAccountNumber.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredFrauds = filteredGroups;
      _fraudCount = filteredGroups.length;
    });
    if (_fraudCount > 0) {
      _dangerInfo =
          'WARNING: $_fraudCount reports found for this account number!';
    } else {
      _dangerInfo = '';
    }
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
              decoration: const InputDecoration(
                labelText: 'Search by Account Number',
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
                final fraudName = fraud['fraudName'] ?? '';
                final fraudDescription = fraud['description'] ?? '';
                final fraudbankname = fraud['bankName'] ?? '';
                final fraudifsc = fraud['ifsc'] ?? '';
                final fraudtransactionid = fraud['transactionID'] ?? '';
                final fraudaccountnumber = fraud['accountNumber'] ?? '';
                return ListTile(
                  title: Row(
                    children: [
                      const Text(
                        "Name - ",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        fraudName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      const Text("  A/C    - "),
                      Text(fraudaccountnumber,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => BankDetailScreen(
                              images: fraud['images'],
                              desc: fraudDescription,
                              fraudName: fraudName,
                              WalletName: fraudbankname,
                              bankifsc: fraudifsc,
                              phoneNumber: fraudaccountnumber,
                              transactionID: fraudtransactionid)),
                    );
                  },
                );
              },
            ),
          ),
          if (_dangerInfo.isNotEmpty) // Display the danger info only once
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _dangerInfo,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BankFraud(user: widget.user)));
        },
      ),
    );
  }
}
