import 'dart:developer';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fraudrader/view/homePage.dart';
import 'package:fraudrader/authenticate/registerAct.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpWithGooglePage extends StatefulWidget {
  const SignUpWithGooglePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpWithGooglePageState createState() => _SignUpWithGooglePageState();
}

class _SignUpWithGooglePageState extends State<SignUpWithGooglePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoad = false;

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential user = await _auth.signInWithCredential(credential);

      await FirebaseFirestore.instance
          .collection('tempusers')
          .doc(user.user?.uid)
          .set({
            'uid': user.user?.uid,
            'name': user.user?.displayName,
            'phoneNumber': '',
            'email': user.user?.email,
            'photoUrl': user.user?.photoURL,
            'joiningDate': FieldValue.serverTimestamp(),
          })
          .then((value) => log('User Added'))
          .catchError((error) => log('Failed to add user: $error'));
      return user;
    } catch (e) {
      setState(() {});
      log(e.toString());
      return null;
    }
  }

  void _navigateToHomePage() {
    User? user = FirebaseAuth.instance.currentUser!;
    if (user.phoneNumber != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeAct(user: user),
        ),
      );
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => RegisterAct()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: isLoad
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  color: Colors.white,
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset('images/scam.png'),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: GoogleAuthButton(
                            themeMode: ThemeMode.dark,
                            onPressed: () async {
                              setState(() {
                                isLoad = true;
                              });

                              _signInWithGoogle().then((userCredential) {
                                if (userCredential != null) {
                                  _navigateToHomePage();
                                }
                              });
                            })),
                  ]))),
    );
  }
}
