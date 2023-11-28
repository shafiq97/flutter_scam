import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false;
  User? _firebaseUser;
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _firebaseUser = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() => _isLoading = true);
    DocumentSnapshot userDocument = await FirebaseFirestore.instance
        .collection('tempusers')
        .doc(_firebaseUser?.uid)
        .get();
    if (userDocument.exists) {
      _userData = userDocument.data() as Map<String, dynamic>;
      _phoneNumberController.text = _userData['phoneNumber'] ?? '';
    }
    setState(() => _isLoading = false);
  }

  Future<void> _updatePhoneNumber() async {
    setState(() => _isLoading = true);
    await FirebaseFirestore.instance
        .collection('tempusers')
        .doc(_firebaseUser?.uid)
        .update({'phoneNumber': _phoneNumberController.text}).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number updated successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating phone number: $error')),
      );
    }).whenComplete(() => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_firebaseUser != null) ...[
                    Text('Name: ${_userData['name'] ?? 'Not provided'}'),
                    Text('Email: ${_firebaseUser!.email ?? 'Not provided'}'),
                    const SizedBox(height: 20),
                  ],
                  TextField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updatePhoneNumber,
                    child: const Text('Update Phone Number'),
                  ),
                  // Optionally, you can display and edit other user information here
                ],
              ),
            ),
    );
  }
}
