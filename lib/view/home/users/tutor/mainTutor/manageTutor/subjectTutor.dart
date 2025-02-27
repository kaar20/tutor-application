import '/controller/profiledata.dart';
import '/controller/subjectdata.dart';
import '/model/profile.dart';
import '/view/home/users/globalWidgetTutor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/model/global.dart';

class SubjectTutor extends StatefulWidget {
  @override
  _SubjectTutorState createState() => _SubjectTutorState();
}

class _SubjectTutorState extends State<SubjectTutor> {
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context);
    final String hd = 'Subject';

var _subjectState = List.filled(subjectList.length, false);
    for (int i = 0; i < subjectList.length; i++) {
      if (profile.subject != null) {
        if (profile.subject.contains(subjectList[i].eng.toLowerCase())) {
          _subjectState[i] = true;
        } else {
          _subjectState[i] = false;
        }
      } else {
        _subjectState[i] = false;
      }
    }

    return Scaffold(
      backgroundColor: yl,
      appBar: PreferredSize(
        child: Header(hd: hd, bl: bl, wy: wy),
        preferredSize: const Size.fromHeight(80.0),
      ),
      body: Container(
        color: wy,
        //controller: _tabController,
        child: Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 10,
            right: 8,
          ),
          decoration: BoxDecoration(
            color: yl,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
            ),
          ),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                    child: Text(
                        'Please click subject you teach until turns green')),
              ),
              Expanded(
                child: GridView.count(
                  childAspectRatio: 2,
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 10,
                  children: List.generate(
                    subjectList.length,
                    (index) => FilterChip(
                      selectedColor: _subjectState[index] ? gn : rd,
                      backgroundColor: _subjectState[index] ? gn : rd,
                      selected: _subjectState[index],
                      label: Container(
                          width: 100,
                          child: Text(
                            subjectList[index].eng,
                            style: const TextStyle(fontSize: 15),
                          )),
                      padding: const EdgeInsets.all(30),
                      //avatar: Text('W'),
                      onSelected: (bool selected) async {
                        setState(() {
                          _subjectState[index] = !_subjectState[index];
                        });
                        if (_subjectState[index]) {
                          // add in subject collection
                          await SubjectDataService(uid: profile.uid)
                              .addSubjectTutorSPM(
                                  profile.fullName,
                                  profile.image,
                                  subjectList[index].eng.toLowerCase(),
                                  profile.price);

                          // add in profile collection
                          await ProfileDataService(uid: profile.uid)
                              .updateSubject(
                                  subjectList[index].eng.toLowerCase());
                        } else {
                          // remove in profile collection
                          await SubjectDataService(uid: profile.uid)
                              .deleteSubjectTutorSPM(
                                  subjectList[index].eng.toLowerCase());

                          // remove from profile subject array
                          await ProfileDataService(uid: profile.uid)
                              .deleteSubject(
                                  subjectList[index].eng.toLowerCase());
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
