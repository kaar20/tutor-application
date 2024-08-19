import 'ratedata.dart';
import '/model/rate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/model/feedback.dart';

class FeedDataService {
  final String uid;
  FeedDataService({required this.uid});

  // feed collection reference
  final CollectionReference feedCollection =
      FirebaseFirestore.instance.collection('feedback');

  FeedList _feedFromSnapshot(DocumentSnapshot snapshot) {
    // Check if snapshot data is available and cast it to Map<String, dynamic>
    final data = snapshot.data() as Map<String, dynamic>?;

    return FeedList(
      fdb: data?['feed'] ?? [],
    );
  }

  // get profile stream
  Stream<FeedList> get feedback {
    return feedCollection.doc(uid).snapshots().map(_feedFromSnapshot);
  }

  Future<void> createFeedbackData() async {
    return await feedCollection.doc(uid).set({
      "feed": [],
    });
  }

  Future<void> addFeedbackData(String fd, String sb, String tn, double rt) async {
    return await feedCollection.doc(uid).update({
      "feed": FieldValue.arrayUnion([
        {
          "fd": fd,
          "sb": sb,
          "tn": tn,
          "rt": rt,
        },
      ])
    });
  }
}
