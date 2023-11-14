import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImgPick extends StatefulWidget {
  @override
  _ImgPickState createState() => new _ImgPickState();
}

class _ImgPickState extends State<ImgPick> {
  final auth.User user = auth.FirebaseAuth.instance.currentUser!;
  List<Asset> images = [];
  String _error = '';

  @override
  void initState() {
    super.initState();
  }


  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          quality: 50,
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  List<String> imagepaths = [];

  Future<void> loadAssets() async {
    List<Asset> resultList = [];
    String error = 'No Error Detected';

    try {
      images = [];
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Pick photos",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      ).then((value) {
        value.forEach((element) {
          imagepaths.add(element.identifier!);
        });
        return value;
      });
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
        title: const Text(
          'Pick Images',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _error.isNotEmpty ? Center(child: Text('$_error')) : Container(),
            ElevatedButton(
              child: Text("Pick images"),
              onPressed: loadAssets,
            ),
            Expanded(
              child: buildGridView(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).pop(imagepaths);
        },
        child: Icon(Icons.cloud_upload),
      ),
    );
  }

  List<String> downloadUrls = [];
  bool uploading = false;
  bool uploaded = false;

  // Upload file to Firebase Storage
  Future<void> upload(String imageFile) async {
    DateTime time = DateTime.now();
    var ref = FirebaseStorage.instance
        .ref()
        .child('bank')
        .child(user.uid)
        .child(time.microsecondsSinceEpoch.toString());

    var uploadTask = await ref.putFile(File(imageFile));
    var url = await uploadTask.ref.getDownloadURL();

    print(url);

    return downloadUrls.add(url);
  }
}
