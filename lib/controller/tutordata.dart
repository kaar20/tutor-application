//import 'dart:html';

import '/model/session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TutorDataService {
  //String sessid;
  String id;
  TutorDataService({required this.id});

  // session collection reference
  final CollectionReference sessionCollection =
      FirebaseFirestore.instance.collection('session');

  // tutor session add
  Future addTutorSession(String tutorid, String tuteeid, String subject,
      String date, String day, int slot, String venue) async {
    return await sessionCollection.add({
      'tutorid': tutorid,
      'tuteeid': tuteeid,
      'subject': subject,
      'date': date,
      'day': day,
      'slot': slot,
      'venue': venue,
      'status': 'pending',
      'rate': true,
      'mark': true,
    });
    //.then((value) => sessid = value.documentID);
  }
List<Session> _sessionFromSnapshot(QuerySnapshot<Object?> snapshot) {
  return snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
    return Session(
      doc.id, // sessid
      data['tutorid'] ?? '', // tutorid
      data['tutornm'] ?? '', // tutornm
      data['tuteeid'] ?? '', // tuteeid
      data['tuteenm'] ?? '', // tuteenm
      data['subject'] ?? '', // subject
      data['date'] ?? '', // date
      data['day'] ?? '', // day
      data['venue'] ?? '', // venue
      data['slot'] ?? 0, // slot
      data['status'] ?? '', // status
      data['rate'] ?? false, // rate
      data['mark'] ?? false, // mark
    );
  }).toList();
}
// get session stream for tutor
  Stream<List<Session>> get sessiontutor {
    return sessionCollection
        .where('tutorid', isEqualTo: id)
        .snapshots()
        .map(_sessionFromSnapshot);
  }

  // update rate data
  Future updateRateData() async {
    return await sessionCollection.doc(id).update({
      'rate': false,
    });
  }

  // update mark data
  Future updateMarkData() async {
    return await sessionCollection.doc(id).update({
      'mark': false,
    });
  }

  // update tutor session
  Future updateTutorSessionData(String sessid, String status) async {
    return await sessionCollection.doc(sessid).update({
      'status': status,
    });
  }

  // update tutor session
  Future feedTutorSessionData(String sessid, bool rate) async {
    return await sessionCollection.doc(sessid).update({
      'rate': rate,
    });
  }

  // get session stream for tutee
  Stream<List<Session>> get sessiontutee {
    return sessionCollection
        .where('tuteeid', isEqualTo: id)
        .snapshots()
        .map(_sessionFromSnapshot);
  }
}
