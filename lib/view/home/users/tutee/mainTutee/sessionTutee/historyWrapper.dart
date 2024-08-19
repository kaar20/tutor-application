import '/controller/ratedata.dart';
import '/model/rate.dart';
import '/view/home/users/tutee/mainTutee/sessionTutee/historyTutee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryWrapper extends StatelessWidget {
  final String uid;
  HistoryWrapper({required this.uid});
  //const HistoryWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: RateDataService(uid: uid).rating,
builder: (BuildContext context, AsyncSnapshot<Rate> snapshot) {
  if (snapshot.hasData) {
return Text(''); // Assuming Rate has a 'rating' property
  } else if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}');
  } else {
    return CircularProgressIndicator();
  }
},    );
  }
}
