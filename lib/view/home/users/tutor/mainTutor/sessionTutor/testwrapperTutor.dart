import '/controller/tutordata.dart';
import '/model/profile.dart';
import '/model/session.dart';
import '/view/home/users/tutee/dashboardTutee.dart';
import '/view/home/users/tutee/mainTutee/sessionTutee/historyTutee.dart';
import '/view/home/users/tutee/mainTutee/sessionTutee/ongoingTutee.dart';
import '/view/home/users/tutee/mainTutee/sessionTutee/pendingTutee.dart';
import '/view/home/users/tutee/mainTutee/sessionTutee/rejectTutee.dart';
import '/view/home/users/tutee/mainTutee/sessionTutee/unpaidTutee.dart';
import '/view/home/users/tutor/mainTutor/sessionTutor/historyTutor.dart';
import '/view/home/users/tutor/mainTutor/sessionTutor/rejectTutor.dart';
import '/view/home/users/tutor/mainTutor/sessionTutor/unpaidTutor.dart';
import '/view/home/users/tutor/mainTutor/sessionTutor/ongoingTutor.dart';
import '/view/home/users/tutor/mainTutor/sessionTutor/pendingTutor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestWrapperTutor extends StatelessWidget {
  final String destination;
  TestWrapperTutor({Key? key, required this.destination}) : super(key: key);

  Widget thePage(String ds) {
    switch (ds) {
      case 'pending':
        return PendingTutor();
        break;

      case 'accept':
        return OngoingTutor();
        break;

      case 'unpaid':
        return UnpaidTutor();
        break;

      case 'complete':
        return HistoryTutor();
        break;

      case 'reject':
        return RejectTutor();
        break;

      default:
        return DashboardTutee();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context);

    return StreamProvider<List<Session>>.value(
      value: TutorDataService(id: profile.uid).sessiontutor,
      initialData: [],
      child: thePage(destination),
    );
  }
}
