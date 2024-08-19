import '/controller/tutordata.dart';
import '/model/profile.dart';
import '/model/session.dart';
import '/view/home/users/tutee/dashboardTutee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionWrapperTutee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context);

    return StreamProvider<List<Session>>.value(
      value: TutorDataService(id: profile.uid).sessiontutee,
      initialData: [],
      child: DashboardTutee(),
    );
  }
}
