import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fraudrader/authenticate/googleSignIn.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  AppDrawer({required this.userName, required this.userEmail});
  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),

          ListTile(
            leading: Icon(Icons.policy),
            title: Text('Privacy Policy'),

          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
  void _logout(BuildContext context) async{

      await GoogleSignIn().signOut();


    FirebaseAuth.instance.signOut().then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => SignUpWithGooglePage()),
      );
    }).catchError((error) {
      print('Logout error: $error');
    });
  }

}
