import '/model/schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleDataService {
  final String uid;

  ScheduleDataService({required this.uid});

  // Schedule collection reference
  final CollectionReference scheduleCollection =
      FirebaseFirestore.instance.collection('profile');

  // Update schedule data
  Future<void> updateScheduleData(String day, String slot, bool event) async {
    return await scheduleCollection
        .doc(uid)
        .collection('schedule')
        .doc(day)
        .update({
      slot: event,
    });
  }

  // Create schedule collection
  Future<void> createScheduleData() async {
    bool slot = false;
    List<String> days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

    for (int a = 0; a < days.length; a++) {
      await scheduleCollection
          .doc(uid)
          .collection('schedule')
          .doc(days[a])
          .set({
        'order': a + 1,
        'slot1': slot,
        'slot2': slot,
        'slot3': slot,
      });
    }
  }

  // Convert QuerySnapshot to List<Schedule>
  List<Schedule> _scheduleFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>?;

      return Schedule(
        id: doc.id,
        slot1: data?['slot1'] as bool? ?? false,
        slot2: data?['slot2'] as bool? ?? false,
        slot3: data?['slot3'] as bool? ?? false,
      );
    }).toList();
  }

  // Get schedule data stream
  Stream<List<Schedule>> get schedule {
    return scheduleCollection
        .doc(uid)
        .collection('schedule')
        .orderBy('order')
        .snapshots()
        .map(_scheduleFromSnapshot);
  }
}
