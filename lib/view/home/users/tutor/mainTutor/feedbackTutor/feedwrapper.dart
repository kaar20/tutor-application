import '/controller/feeddata.dart';
import '/model/feedback.dart';
import '/model/profile.dart';
import '/view/home/users/tutor/mainTutor/feedbackTutor/feedbackTutor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedWrapper extends StatelessWidget {
  //const FeedWrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context);

    return StreamProvider<FeedList>.value(
      value: FeedDataService(uid: profile.uid).feedback,
initialData: FeedList(fdb: []),
      child: FeedbackTutor(),
    );
  }
}
