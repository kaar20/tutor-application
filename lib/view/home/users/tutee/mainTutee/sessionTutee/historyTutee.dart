import '/controller/feeddata.dart';
import '/controller/profiledata.dart';
import '/controller/ratedata.dart';
import '/controller/tutordata.dart';
import '/model/feedback.dart';
import '/model/profile.dart';
import '/model/rate.dart';
import '/model/session.dart';
import '/view/home/loading.dart';
import '/view/home/users/tutee/mainTutee/rateTutee/rateSession.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '/model/global.dart';
import '/view/home/users/globalWidgetTutor.dart';
import '/view/home/users/tutee/mainTutee/sessionTutee/widgetSessionTutee.dart';

class HistoryTutee extends StatefulWidget {
  @override
  _HistoryTuteeState createState() => _HistoryTuteeState();
}

class _HistoryTuteeState extends State<HistoryTutee> {
  @override
  Widget build(BuildContext context) {
    final session = Provider.of<List<Session>>(context);
    final profile = Provider.of<Profile>(context);
    // final oldRate = Provider.of<Rate>(context);

final sessionData = <Session>[];
    final String hd = 'COMPLETED';
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _feedbackController = TextEditingController();

    if (session == null) {
      Loading();
    } else {
      session.forEach((element) {
        element.status == 'complete' ? sessionData.add(element) : null;
      });
    }

    if (sessionData.isNotEmpty) {
      return Scaffold(
        backgroundColor: yl,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Header(hd: hd, bl: bl, wy: wy),
        ),
        body: Container(
          color: wy,
          child: Container(
            padding: EdgeInsets.only(
              top: 20,
              left: 10,
              right: 8,
            ),
            decoration: BoxDecoration(
              color: yl,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
              ),
            ),
            child: ListView.builder(
              itemCount: sessionData.length,
              itemBuilder: (context, i) {
                // stream for tutor profile
                return StreamBuilder(
                  stream:
                      ProfileDataService(uid: sessionData[i].tutorid).profile,
                  builder:
                      (BuildContext context, AsyncSnapshot<Profile> snapshot) {
                    if (snapshot.hasData) {
                      {
                        return Container(
                          decoration: BoxDecoration(
                            color: wy,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          margin: EdgeInsets.all(20),
                          child: Column(
                            children: <Widget>[
                              //Text(sessionData[index].sessid),
                              Container(
                                padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(children: <Widget>[
                                      Text(
                                        sessionData[i].subject.toUpperCase(),
                                        style: sb,
                                      ),
                                      SizedBox(height: 20),
                                      ProfileDisplay(
                                          snapshot: snapshot,
                                          sessionData: sessionData,
                                          index: i),
                                      SizedBox(height: 25),
                                      Container(
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              // RaisedButton(
                                              //     color: Colors.blue[300],
                                              //     child: Text('Completed'),
                                              //     onPressed: () {}),
                                              TextButton(
                                                // color: Colors.blue[300],
                                                child: Text('Rate'),
                                                onPressed: sessionData[i].rate
                                                    ? () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Feedback(
                                                                uid: sessionData[
                                                                        i]
                                                                    .tutorid,
                                                                sessid:
                                                                    sessionData[
                                                                            i]
                                                                        .sessid,
                                                                sesssub:
                                                                    sessionData[
                                                                            i]
                                                                        .subject,
                                                                formKey:
                                                                    _formKey,
                                                                fdController:
                                                                    _feedbackController,
                                                                teename: profile
                                                                    .fullName,
                                                              );
                                                            });
                                                      }
                                                    : null,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return Loading();
                    }
                  },
                );
              },
            ),
          ),
        ),
      );
    } else {
      return NoSession(hd: hd, yl: yl, bl: bl, wy: wy);
    }
  }
}

class Feedback extends StatelessWidget {
  const Feedback({
    Key? key,
    required GlobalKey<FormState> formKey,
    required TextEditingController fdController,
    required String uid,
    required String sessid,
    required String sesssub,
    required String teename,
    //@required double oldRate,
  })  : _formKey = formKey,
        _fdController = fdController,
        _uid = uid,
        _sessid = sessid,
        _sesssub = sesssub,
        _teename = teename,
        //_oldRate = oldRate,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController _fdController;
  final String _uid, _sesssub, _sessid, _teename;
  //final double _oldRate;

  @override
  Widget build(BuildContext context) {
    double _rate = 0;

    return AlertDialog(
      content: Stack(
        clipBehavior: Clip.none, children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close, color: yl),
                backgroundColor: bl,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    maxLines: 3,
                    decoration:
                        InputDecoration(labelText: "Enter your feedback"),

                    controller: _fdController,
                    //initialValue: 'Enter you feedback',
                  ),
                ),
                SizedBox(height: 30),
                RatingBar.builder(
                  initialRating: _rate,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _rate = rating;
                    print(rating);
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextButton(
                    // color: bl,
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        letterSpacing: 1.5,
                      ),
                    ),
                    onPressed: () async {
                      //await FeedDataService(uid: _uid).createFeedbackData();

                      await FeedDataService(uid: _uid).addFeedbackData(
                          _fdController.text, _sesssub, _teename, _rate);
                      await TutorDataService(id: _sessid).updateRateData();
                      await RateDataService(uid: _uid).getRateData(_rate);
                      // await RateDataService(uid: _uid)
                      //   .updateRatingData(_oldRate, _rate);
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
