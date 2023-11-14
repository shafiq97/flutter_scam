import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhoneFraudImages extends StatefulWidget {
  @override
  State<PhoneFraudImages> createState() => _PhoneFraudImagesState();
}

class _PhoneFraudImagesState extends State<PhoneFraudImages> {
  List<String>? imageAddress;
  List<XFile>? images;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
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
                    pickedimages = await pickImage();
                    // images= pickedimages;
                    if (pickedimages != null && pickedimages!.isNotEmpty) {
                      // multiImages = await multiImageUploader(_images);
                      setState(() {});
                    }
                  },
                  //   height: 20,
                  //  color: Colors.blue,
                  child: const Text(
                    "Upload images of evidence",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            if (pickedimages != null)
              Wrap(
                children: pickedimages!
                    .map(
                      (e) => Stack(
                        children: [
                          Image.file(
                            File(e.path),
                            height: 200,
                            width: 200,
                            //   width: 200,
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  pickedimages?.remove(e);
                                });
                              },
                              color: Colors.red,
                              icon: Icon(Icons.cancel))
                        ],
                      ),
                    )
                    .toList(),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

List<String>? multiImages;
List<XFile>? pickedimages;
String? title;

Future<String> uploadOne(XFile image, String title) async {
  DateTime time = DateTime.now();
  Reference db = FirebaseStorage.instance
      .ref()
      .child('mobtemp')
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child(time.microsecondsSinceEpoch.toString());

  await db.putFile(File(image.path));
  return db.getDownloadURL();
}

Future<List<String>> multiImageUploader(List<XFile> list) async {
  List<String> _path = [];

  for (XFile _images in list) {
    _path.add(await uploadOne(_images, 'temp'));
  }
  return _path;
}

Future<List<XFile>> pickImage() async {
  List<XFile>? _images = await ImagePicker().pickMultiImage();
  for(var x in _images){
    print(getImageName(x));
  }
  if (_images != null && _images.isNotEmpty) {
    return _images;
  }
  return [];
}

String getImageName(XFile image) {
  return image.path.split("/").last;
}


