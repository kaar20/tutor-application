import '/controller/evaluatedata.dart';
import '/model/evaluate.dart';
import '/model/profile.dart';
import '/view/home/users/tutee/mainTutee/subjectTutee/subjectTutee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectWrapperTutee extends StatelessWidget {
  //const SubjectWrapperTutee({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context);

    return StreamProvider<EvaluateList>.value(
      value: EvaluateDataService(uid: profile.uid).evaluation,
      child: SubjectTutee(),
catchError: (_, __) => EvaluateList(evaluateList: []), initialData: EvaluateList(evaluateList: []),    );
  }
}
