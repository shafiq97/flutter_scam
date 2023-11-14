import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../utilities/PhoneImgPicker.dart';


class PhoneFraud extends StatefulWidget {
  User user;
  PhoneFraud({required this.user});

  @override
  _PhoneFraudState createState() => _PhoneFraudState();
}

class _PhoneFraudState extends State<PhoneFraud> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController walletName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController transactionID = TextEditingController();
  final TextEditingController description = TextEditingController();
  String selectedPhoneCode = "+91";
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
        title: const Text("Details"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              giveSpace(),
              customInputField('Name', firstName, TextInputType.name, Icons.person),
              giveSpace(),
              customInputField('Wallet Name', walletName, TextInputType.multiline, Icons.account_balance_wallet_rounded),
              giveSpace(),
              Row(
                children: [
                  CountryCodePicker(
                    onChanged: (CountryCode countryCode) =>
                        setState(() => selectedPhoneCode = countryCode.dialCode!),
                    initialSelection: 'IN',
                    favorite: [ 'IN'],
                  ),
                  Expanded(child: customInputField('Phone Number', phoneNumber, TextInputType.phone, Icons.phone)),
                ],
              ),
              giveSpace(),
              customInputField('Transaction Id', transactionID, TextInputType.multiline, Icons.confirmation_number_outlined),
              giveSpace(),
              customInputField('Description', description, TextInputType.multiline,Icons.insert_drive_file_outlined ),
              giveSpace(),
              PhoneFraudImages(),
              giveSpace(),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                width: 400,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                  color: Colors.blue.shade800,
                  child: MaterialButton(
                    onPressed: () async {

                      //  uploading the files and storing the data to the firestore
                      if (_formKey.currentState!.validate()) {

                        multiImages = await multiImageUploader(pickedimages!);
                        FirebaseFirestore.instance.collection('mob').add({
                          'firstName': firstName.text,
                          'WalletName': walletName.text,
                          'countryCode': selectedPhoneCode,
                          'phoneNumber': phoneNumber.text,
                          'transactionID': transactionID.text,
                          'description': description.text,
                          'images': multiImages
                        }).whenComplete(() {
                          Fluttertoast.showToast(msg: "Fraud Details uploaded :) ");
                        });

                        print(firstName.text);
                        print(walletName.text);
                        print(phoneNumber.text);
                        print(transactionID.text);
                        print(description.text);
                        print('validated');
                        Navigator.pop(context);

                      }
                      else{
                        print('enter values');
                        Fluttertoast.showToast(msg: "Enter all Fields :( ");
                      }
                    },
                    child: const Text(
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

  Widget giveSpace(){
    return SizedBox(
      height: 18,
    );
  }

  Widget customInputField(String hintText, TextEditingController controller, TextInputType keyboardType, IconData iconData){
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
        ),),
    );
  }
}