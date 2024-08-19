import '/model/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDataService {
  final String uid;
  ProfileDataService({required this.uid}) {
    if (uid.isEmpty) {
      throw ArgumentError('UID must not be empty');
    }
  }

  // Profile collection reference
  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profile');

  // Convert Firestore snapshot to Profile object
  Profile _profileFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    return Profile(
      uid: uid,
      type: data?['userType'],
      fullName: data?['fullName'],
      phoneNumber: data?['phoneNumber'],
      bio: data?['bio'],
      address: data?['address'],
      education: data?['education'],
      extraInfo: data?['extraInfo'],
      image: data?['image'],
      exam: data?['exam'],
      subject: data?['subject'],
      price: data?['price'],
    );
  }

  // Get profile stream
  Stream<Profile> get profile {
    return profileCollection
        .doc(uid)
        .snapshots()
        .map(_profileFromSnapshot);
  }

  // Create profile data
  Future<void> createProfileData(
      bool userType, String fullName, String phoneNumber) async {
    if (uid.isEmpty) {
      throw ArgumentError('UID must not be empty');
    }
    return await profileCollection.doc(uid).set({
      'userType': userType,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'bio': 'Please fill',
      'address': 'Please fill',
      'education': 'Please fill',
      'extraInfo': 'Please fill',
      'image': userType ? "me" : "tuu",
      'subject': [],
      'price': 0.0,
    });
  }

  // Update profile data
  Future<void> updateProfileData(String name, String bio, String phone,
      String address, String education, String extra) async {
    if (uid.isEmpty) {
      throw ArgumentError('UID must not be empty');
    }
    return await profileCollection.doc(uid).update({
      'fullName': name,
      'phoneNumber': phone,
      'bio': bio,
      'address': address,
      'education': education,
      'extraInfo': extra,
    });
  }

  // Update price rate data
  Future<void> updatePriceData(double price) async {
    if (uid.isEmpty) {
      throw ArgumentError('UID must not be empty');
    }
    return await profileCollection.doc(uid).update({
      'price': price,
    });
  }

  // Update subjects array
  Future<void> updateSubject(String subject) async {
    if (uid.isEmpty) {
      throw ArgumentError('UID must not be empty');
    }
    return await profileCollection.doc(uid).update({
      'subject': FieldValue.arrayUnion([subject]),
    });
  }

  // Delete subject from array
  Future<void> deleteSubject(String subject) async {
    if (uid.isEmpty) {
      throw ArgumentError('UID must not be empty');
    }
    return await profileCollection.doc(uid).update({
      'subject': FieldValue.arrayRemove([subject]),
    });
  }

  // Update teaching info
  Future<void> updateTutoringData(String subject) async {
    if (uid.isEmpty) {
      throw ArgumentError('UID must not be empty');
    }
    return await profileCollection
        .doc(uid)
        .update({'subject': subject});
  }

  // Update image data
  Future<void> updateProfileImageData(String url) async {
    if (uid.isEmpty) {
      throw ArgumentError('UID must not be empty');
    }
    return await profileCollection.doc(uid).update({
      'image': url,
    });
  }
}
