import '/controller/ratedata.dart';
import '/controller/tutordata.dart';
import '/model/profile.dart';
import '/model/rate.dart';
import '/model/session.dart';
import '/view/home/users/tutee/dashboardTutee.dart';
import '/view/home/users/tutee/mainTutee/sessionTutee/historyTutee.dart';
import '/view/home/users/tutee/mainTutee/sessionTutee/unpaidTutee.dart';
import '/view/home/users/tutee/mainTutee/sessionTutee/ongoingTutee.dart';
import '/view/home/users/tutee/mainTutee/sessionTutee/pendingTutee.dart';
import '/view/home/users/tutee/mainTutee/sessionTutee/rejectTutee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestWrapperTutee extends StatelessWidget {
  final String destination;
  TestWrapperTutee({Key? key, required this.destination});

  Widget thePage(String ds) {
    switch (ds) {
      case 'pending':
        return PendingTutee();
        break;

      case 'accept':
        return OngoingTutee();
        break;

      case 'unpaid':
        return UnpaidTutee();
        break;

      case 'complete':
        return HistoryTutee();
        break;

      case 'reject':
        return RejectTutee();
        break;

      default:
        return DashboardTutee();
    }
  }

  //TestWrapperTutee({Key key, this.destination});
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context);

    return StreamProvider<List<Session>>.value(
      value: TutorDataService(id: profile.uid).sessiontutee,
      initialData: [],
      child: thePage(destination),
    );
  }
}
