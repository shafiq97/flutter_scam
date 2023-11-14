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
      final fraudName = group['firstName'] ?? '';
      final fraudDescription = group['accountNumber'] ?? '';
      return fraudName.toLowerCase().contains(query.toLowerCase()) ||
          fraudDescription.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredFrauds = filteredGroups;
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
                      Text("Name - ",style: TextStyle(fontSize: 15),),
                      Text(fraudName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text("  A/C    - "),
                      Text(fraudaccountnumber,style: TextStyle(fontWeight: FontWeight.bold)),
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
                            transactionID: fraudtransactionid)
                      ),
                    );

                  },
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
              builder: (context) => BankFraud(user: widget.user)));
        },
      ),
    );
  }
}
