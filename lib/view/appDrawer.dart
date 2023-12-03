import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fraudrader/authenticate/googleSignIn.dart';
import 'package:fraudrader/view/contact.dart';
import 'package:fraudrader/view/profile.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  const AppDrawer({super.key, required this.userName, required this.userEmail});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text('Contact Us'),
            onTap: () => _contact(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('Profile'),
            onTap: () => _profile(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    await GoogleSignIn().signOut();

    FirebaseAuth.instance.signOut().then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const SignUpWithGooglePage()),
      );
    }).catchError((error) {
      print('Logout error: $error');
    });
  }

  void _profile(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const UserProfilePage()),
    );
  }

  void _contact(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => ContactUsPage()),
    );
  }
}
