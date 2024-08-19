import 'dart:io';
import '/controller/profiledata.dart';
import '/model/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageTutor extends StatefulWidget {
  @override
  _ImageTutorState createState() => _ImageTutorState();
}

class _ImageTutorState extends State<ImageTutor> {
  File? _image; // Change to File? to handle null values
  String returnURL = ''; // Initialize returnURL with an empty string

  // Image Picker
  Future<void> getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source); // Use pickImage method

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    if (_image == null) return; // Ensure _image is not null

    final firebaseStorage = FirebaseStorage.instance.ref().child('images/${_image!.path.split('/').last}');
    final uploadTask = firebaseStorage.putFile(_image!);

    // Await the completion of the upload task
    await uploadTask;

    final fileURL = await firebaseStorage.getDownloadURL();
    setState(() {
      returnURL = fileURL;
    });

    print('Image Uploaded!');
    print('Image URL: $returnURL');

    // Optionally update profile image data after upload
    await ProfileDataService(uid: Provider.of<Profile>(context, listen: false).uid)
        .updateProfileImageData(returnURL);
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context);

    return Scaffold(
      body: Center(
        child: Container(
          child: ListView(
            children: <Widget>[
              ClipOval(
                child: SizedBox(
                  height: 300.0,
                  width: 300.0, // Changed to 300.0 to match height
                  child: (_image != null)
                      ? Image.file(_image!)
                      : Image.network(
                          profile.image,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              RawMaterialButton(
                fillColor: Theme.of(context).cardColor,
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                ),
                elevation: 8,
                onPressed: () async {
                  await getImage(ImageSource.gallery); // Wait for image selection
                  if (returnURL.isNotEmpty) {
                    await ProfileDataService(uid: profile.uid)
                        .updateProfileImageData(returnURL);
                  }
                },
                padding: EdgeInsets.all(15),
                shape: CircleBorder(),
              ),
              ElevatedButton(
                onPressed: () {
                  uploadImage(context);
                },
                child: Text('Upload'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
