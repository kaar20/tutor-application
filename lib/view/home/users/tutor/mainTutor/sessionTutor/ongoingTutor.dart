import '/controller/profiledata.dart';
import '/controller/tutordata.dart';
import '/model/profile.dart';
import '/model/session.dart';
import '/view/home/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/model/global.dart';
import '/view/home/users/globalWidgetTutor.dart';
import '/view/home/users/tutor/mainTutor/sessionTutor/widgetSessionTutor.dart';

class OngoingTutor extends StatefulWidget {
  @override
  _OngoingTutorState createState() => _OngoingTutorState();
}

class _OngoingTutorState extends State<OngoingTutor> {
  @override
  Widget build(BuildContext context) {
    final session = Provider.of<List<Session>>(context);
    final sessionData =  <Session>[];
    final String hd = 'ONGOING';

    if (session == null) {
      Loading();
    } else {
      session.forEach((element) {
        element.status == 'accept' ? sessionData.add(element) : null;
      });
    }

    if (sessionData.isNotEmpty) {
      return Scaffold(
        appBar: PreferredSize(
          child: Header(hd: hd, bl: bl, wy: wy),
          preferredSize: Size.fromHeight(80.0),
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
              itemBuilder: (context, index) {
                if (sessionData[index].status == 'accept') {
                  // stream for tutee profile
                  return StreamBuilder(
                    stream: ProfileDataService(uid: sessionData[index].tuteeid)
                        .profile,
                    builder: (BuildContext context,
                        AsyncSnapshot<Profile> snapshot) {
                      if (snapshot.hasData) {
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
                                padding: EdgeInsets.all(30),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      sessionData[index].subject.toUpperCase(),
                                      style: sb,
                                    ),
                                    SizedBox(height: 20),
                                    ProfileDisplay(
                                        snapshot: snapshot,
                                        sessionData: sessionData,
                                        index: index),
                                    SizedBox(height: 25),
                                    Center(
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 15),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              ElevatedButton(
                                                  // color: gn,
                                                  child: Text('Attended'),
                                                  onPressed: () async {
                                                    await TutorDataService(id: '')
                                                        .updateTutorSessionData(
                                                            sessionData[index]
                                                                .sessid,
                                                            'attend');
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Text('Data not found');
                      }
                    },
                  );
                } else {
                  return NoSession(hd: hd, yl: yl, bl: bl, wy: wy);
                }
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
