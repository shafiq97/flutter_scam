import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../view/homePage.dart';

class RegisterAct extends StatefulWidget {
  @override
  _RegisterActState createState() => _RegisterActState();
}

class _RegisterActState extends State<RegisterAct> {
  String selectedPhoneCode = "+60";

  final TextEditingController numberController = TextEditingController();

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  TextEditingController verificationcode = TextEditingController();
  bool isNumber = false;
  String code = '';
  bool loading = false;
  bool isLoad = false;
  void checkPhoneNumber(String value) {
    if (value.length == 10) {
      if (int.tryParse(value) != null) {
        setState(() {
          isNumber = true;
        });
        return;
      }
    }
    setState(() {
      isNumber = false;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(code == ''
                  ? "Enter your Mobile Number to verify yourself"
                  : "OTP"),
            ),
            const SizedBox(height: 18.0),
            code == ''
                ? Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5,
                    child: Row(
                      children: [
                        CountryCodePicker(
                          onChanged: (CountryCode countryCode) => setState(
                              () => selectedPhoneCode = countryCode.dialCode!),
                          initialSelection: 'MY',
                          favorite: ['MY'],
                        ),
                        Expanded(
                          child: TextField(
                            onChanged: checkPhoneNumber,
                            maxLength: 10,
                            controller: numberController,
                            autocorrect: true,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.blue.shade500,
                            decoration: InputDecoration(
                              hintText: 'Number',
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Colors.blue.shade800,
                              ),
                              hintStyle: TextStyle(color: Colors.blue.shade900),
                              filled: true,
                              fillColor: Colors.white70,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 5,
                      child: TextField(
                        controller: verificationcode,
                        autocorrect: true,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.blue.shade500,
                        decoration: InputDecoration(
                          hintText: 'OTP',
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.blue.shade800,
                          ),
                          hintStyle: TextStyle(color: Colors.blue.shade900),
                          filled: true,
                          fillColor: Colors.white70,
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
            code == ''
                ? Visibility(
                    replacement: const Text('Enter 10 digit number'),
                    visible: isNumber,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      width: 400,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        color: Colors.blue.shade700,
                        child: MaterialButton(
                          onPressed: () async {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeAct(user: _auth.currentUser!)));
                            setState(() {
                              isLoad = true;
                            });
                            //verify the user phone number and link it with firebase user credential.
                            // await _auth.verifyPhoneNumber(
                            //   phoneNumber:
                            //       selectedPhoneCode + numberController.text,
                            //   verificationCompleted: (a) async {
                            //     print('verifivation complete');
                            //   },
                            //   verificationFailed: (e) {
                            //     log(e.toString());
                            //   },
                            //   codeSent: (codesent, cod) async {
                            //     log(codesent.toString());
                            //     setState(() {
                            //       code = codesent;
                            //     });
                            //   },
                            //   codeAutoRetrievalTimeout: (t) {
                            //     print(t);
                            //   },
                            // );
                            setState(() {
                              loading = false;
                            });
                          },
                          child: code == '' && loading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "Verify",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    width: 400,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      color: Colors.blue.shade700,
                      child: MaterialButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          //verify the otp and link with firebase user credential
                          // await _auth.currentUser
                          //     ?.linkWithCredential(
                          //         auth.PhoneAuthProvider.credential(
                          //             verificationId: code,
                          //             smsCode: verificationcode.text))
                          //     .then((value) async {
                          //   await FirebaseFirestore.instance
                          //       .collection('tempusers')
                          //       .doc(_auth.currentUser?.uid)
                          //       .update({
                          //     'phoneNumber': _auth.currentUser?.phoneNumber
                          //   });
                          // });
                          // await FirebaseFirestore.instance
                          //     .collection('tempusers')
                          //     .doc(_auth.currentUser?.uid)
                          //     .update({
                          //   'phoneNumber': _auth.currentUser?.phoneNumber
                          // });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomeAct(user: _auth.currentUser!)));
                        },
                        child:
                            //isLoad ? CircularProgressIndicator():
                            const Text(
                          "Submit otp",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
