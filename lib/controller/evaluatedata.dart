import 'dart:convert';
import '/model/evaluate.dart';
import '/model/profile.dart';
import '/model/rate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EvaluateDataService {
  final String uid;
  EvaluateDataService({required this.uid});

  // evaluation collection reference
  final CollectionReference evCollection =
      FirebaseFirestore.instance.collection('evaluation');

  EvaluateList _evFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return EvaluateList(
      evaluateList: data['evaluate'],
    );
  }

  Stream<EvaluateList> get evaluation {
    return evCollection.doc(uid).snapshots().map(_evFromSnapshot);
  }

  Future createEvaluationData() async {
    return await evCollection.doc(uid).set({
      "evaluate": [],
    });
  }

  // update subject evaluation
  Future updateEvaluationData(String sb, double mk) async {
    return await evCollection.doc(uid).update({
      "evaluate": FieldValue.arrayUnion([
        {
          "sb": sb,
          "mk": mk,
        },
      ])
    });
  }

  // delete subject from array
  Future deleteEvaluationData(String sb, double mk) async {
    return await evCollection.doc(uid).update({
      'evaluate': FieldValue.arrayRemove([
        {'sb': sb, 'mk': mk}
      ]),
    });
  }

  Future getEvData(String sEv, double nEv) async {
    // snapshot evaluation
    DocumentSnapshot evSnapshot = await evCollection.doc(uid).get();
    var evMap = evSnapshot.data() as Map<String, dynamic>;
    List<Evaluate> dataEv = extractEvaluation(evMap['evaluate']);
    double oldEv = 0.0;

    // calculation for new data
    dataEv.forEach((e) {
      if (e.sb == sEv) {
        oldEv = e.mk;
      }
    });
    double pEv = nEv / 5 * 100;
    double newEv = (oldEv + pEv) / 200;
    double percentEv = newEv;

    // remove first and update new one
    await deleteEvaluationData(sEv, oldEv);
    await updateEvaluationData(sEv, percentEv);
  }

  // delete subject from evaluation
  Future deleteEvaluationSubject(String sEv) async {
    // snapshot evaluation
    DocumentSnapshot evSnapshot = await evCollection.doc(uid).get();
    var evMap = evSnapshot.data() as Map<String, dynamic>;
    List<Evaluate> dataEv = extractEvaluation(evMap['evaluate']);

    // calculation for new data
    double oldEv = 0.0;
    dataEv.forEach((e) {
      if (e.sb == sEv) {
        oldEv = e.mk;
      }
    });

    await deleteEvaluationData(sEv, oldEv);
  }
}
