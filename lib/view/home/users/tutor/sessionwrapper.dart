import '/controller/tutordata.dart';
import '/model/profile.dart';
import '/model/session.dart';
import '/view/home/users/tutor/dashboardTutor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionWrapperTutor extends StatefulWidget {
  @override
  _SessionWrapperTutorState createState() => _SessionWrapperTutorState();
}

class _SessionWrapperTutorState extends State<SessionWrapperTutor> {
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context);

    return StreamProvider<List<Session>>.value(
      value: TutorDataService(id: profile.uid).sessiontutor,
      initialData: [],
      child: DashboardTutor(),
    );
  }
}
