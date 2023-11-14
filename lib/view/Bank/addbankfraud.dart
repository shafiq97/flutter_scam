import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fraudrader/utilities/PhoneImgPicker.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class BankFraud extends StatefulWidget {
  User user;
  BankFraud({required this.user});
  @override
  _BankFraudState createState() => _BankFraudState();
}

class _BankFraudState extends State<BankFraud> {
  final auth.User? user = auth.FirebaseAuth.instance.currentUser;
  final TextEditingController fraudName = TextEditingController();
  final TextEditingController bankName = TextEditingController();
  final TextEditingController accountNumber = TextEditingController();
  final TextEditingController transactionID = TextEditingController();
  final TextEditingController ifscCode = TextEditingController();
  final TextEditingController description = TextEditingController();
  List<String>? fraudImages;
  List<String> images = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    multiImages?.clear();
    pickedimages?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              giveSpace(),
              customInputField(
                  'Fraud Name', fraudName, TextInputType.name, Icons.person),
              giveSpace(),
              customInputField('Bank Name', bankName, TextInputType.name,
                  Icons.account_balance_wallet_rounded),
              giveSpace(),
              customInputField('Account Number', accountNumber,
                  TextInputType.name, Icons.numbers_outlined),
              giveSpace(),
              customInputField('Transaction Id', transactionID,
                  TextInputType.multiline, Icons.confirmation_number_outlined),
              giveSpace(),
              customInputField('IFSC Code', ifscCode, TextInputType.name,
                  Icons.insert_drive_file_outlined),
              giveSpace(),
              customInputField('Description', description, TextInputType.name,
                  Icons.insert_drive_file_outlined),
              giveSpace(),
              PhoneFraudImages(),
              giveSpace(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                width: 400,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  color: Colors.blue.shade800,
                  child: MaterialButton(
                    onPressed: () async {
                      //upload files to storage and save the data to firestore
                      if (_formKey.currentState!.validate()) {
                        Fluttertoast.showToast(msg: "Fraud Details uploaded :) ");
                        multiImages = await multiImageUploader(pickedimages!);
                        FirebaseFirestore.instance.collection('ban').add({
                          'fraudName': fraudName.text,
                          'bankName': bankName.text,
                          'accountNumber': accountNumber.text,
                          'transactionID': transactionID.text,
                          'ifsc': ifscCode.text,
                          'description': description.text,
                          'images': multiImages
                        });
                        Navigator.pop(context);
                      }
                      else{
                        Fluttertoast.showToast(msg: "Fill all the fields :( ");
                      }

                    },
                    child: Text(
                      "Submit.",
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
      ),
    );
  }

  Widget giveSpace() {
    return SizedBox(
      height: 18,
    );
  }

  Widget customInputField(String hintText, TextEditingController controller,
      TextInputType keyboardType, IconData iconData) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: TextFormField(
        autofocus: false,
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value!.isEmpty) {
            return ("$hintText cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          controller.text = value!;
        },
        textInputAction: TextInputAction.next,
        cursorColor: Colors.blue.shade800,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            iconData,
            color: Colors.blue.shade800,
          ),
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white70,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}
