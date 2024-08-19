import 'dart:io';
import '/controller/profiledata.dart';
import '/model/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
//import 'package:firebase_storage/firebase_storage.dart';

class ImageTutee extends StatefulWidget {
  @override
  _ImageTuteeState createState() => _ImageTuteeState();
}

class _ImageTuteeState extends State<ImageTutee> {
  late File _image;

Future<void> getImage(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);

  setState(() {
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      print('_image');
      print(_image);
    } else {
      print('No image selected.');
    }
  });
}


late String returnURL;
Future<void> uploadImage(BuildContext context) async {
  final firebaseStorage = FirebaseStorage.instance.ref().child(_image.path);
  final uploadTask = firebaseStorage.putFile(_image);

  await uploadTask.whenComplete(() async {
    print('Image Uploaded!');
    final fileURL = await firebaseStorage.getDownloadURL();
    setState(() {
      returnURL = fileURL;
      print('returnURL');
      print(returnURL);
    });
  });
}

  String getURL() {
    return returnURL;
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context);

    return Scaffold(
      body: Center(
        child: Container(
          child: ListView(children: <Widget>[
            ClipOval(
              child: SizedBox(
                height: 300.0,
                width: 50.0,
                child: (_image != null)
                    ? Image.file(_image)
                    : Image.network(
                        profile.image,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            RawMaterialButton(
              fillColor: Theme.of(context).focusColor,
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
              ),
              elevation: 8,
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              padding: EdgeInsets.all(15),
              shape: CircleBorder(),
            ),
            TextButton(
              onPressed: () async {
                uploadImage(context);
                await ProfileDataService(uid: profile.uid)
                    .updateProfileImageData(getURL());
              },
              child: Text('Upload'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text('Back'),
            )
          ]),
        ),
      ),
    );
  }
}
