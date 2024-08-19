import '/model/rate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RateDataService {
  final String uid;
  RateDataService({required this.uid});

  // Rate collection reference
  final CollectionReference rateCollection =
      FirebaseFirestore.instance.collection('rating');

  Rate _rateFromSnapshot(DocumentSnapshot snapshot) {
    // Ensure data is a Map<String, dynamic>
    final data = snapshot.data() as Map<String, dynamic>?;

    // Extract 'rate' safely
    final rate = data?['rate'] as double? ?? 0.0;

    return Rate(
      theRate: rate,
    );
  }

  Future<void> createRateData() async {
    return await rateCollection.doc(uid).set({
      'rate': 0.0,
    });
  }

  // Update rating
  Future<void> updateRatingData(double oldRate, double newRate) async {
    double theRate = calculateRating(oldRate, newRate);

    return await rateCollection.doc(uid).update({
      'rate': theRate,
    });
  }

  Stream<Rate> get rating {
    return rateCollection.doc(uid).snapshots().map(_rateFromSnapshot);
  }

  Future<void> getRateData(double nRate) async {
    DocumentSnapshot rateSnapshot = await rateCollection.doc(uid).get();
    
    // Ensure 'rate' is handled correctly
    final data = rateSnapshot.data() as Map<String, dynamic>?;
    double oldRate = (data?['rate'] as double?) ?? 0.0;

    print(data.toString());

    return await updateRatingData(oldRate, nRate);
  }

  // Dummy function for rating calculation
  double calculateRating(double oldRate, double newRate) {
    // Implement your rating calculation logic here
    return (oldRate + newRate) / 2; // Example calculation
  }
}
