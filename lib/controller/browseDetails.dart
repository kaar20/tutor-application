import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'profiledata.dart';
import 'scheduledata.dart';
import 'tutordata.dart';
import '/model/global.dart';
import '/model/profile.dart';
import '/model/schedule.dart';
import '/model/user.dart';
import '/view/home/loading.dart';

class BrowseDetails extends StatefulWidget {
  final String idTutor;
  final String subject;

  BrowseDetails({Key? key, required this.idTutor, required this.subject}) : super(key: key);

  @override
  _BrowseDetailsState createState() => _BrowseDetailsState();
}

class _BrowseDetailsState extends State<BrowseDetails> with TickerProviderStateMixin {
  late TabController _tabController;
  late DateTime _bookDate;
  final TutorDataService _session = TutorDataService(id: '');
  final _formKey = GlobalKey<FormState>();

  late String sb;
  late int sl;
  late String vn;
  late String dt;
  late String dy;

  final List<String> _scheduleDay = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  String harini = 'Today';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _bookDate = DateTime.now();
    sl = 0;
    sb = '';
    vn = '';
    dt = '';
    dy = '';
  }

  TextStyle info = const TextStyle(
    fontSize: 18,
    color: Colors.black,
  );

  TextStyle title = const TextStyle(
    fontSize: 15,
    color: Colors.black54,
    height: 1.5,
  );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0),
        child: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.chair,
              color: bl,
              size: 35,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: yl,
          bottom: TabBar(
            labelColor: bl,
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.verified_user)),
              Tab(icon: Icon(Icons.calendar_view_day_rounded)),
              Tab(icon: Icon(Icons.book)),
            ],
            indicatorColor: Colors.black,
          ),
          flexibleSpace: StreamBuilder<Profile>(
            stream: ProfileDataService(uid: widget.idTutor).profile,
            builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('No Profile Data'));
              }

              final profile = snapshot.data!;

              return Container(
                margin: const EdgeInsets.only(top: 10),
                color: yl,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 190,
                      width: double.infinity,
                    ),
                    Positioned(
                      right: 13,
                      child: Container(
                        padding: const EdgeInsets.only(left: 58),
                        height: 150,
                        width: 270,
                        decoration: BoxDecoration(
                          color: wy,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              profile.fullName,
                              style: const TextStyle(fontSize: 23),
                            ),
                            Text(profile.bio),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 48,
                      left: 10,
                      child: ClipOval(
                        child: SizedBox(
                          height: 130.0,
                          width: 130.0,
                          child: Image.network(
                            profile.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          // Profile
          StreamBuilder<Profile>(
            stream: ProfileDataService(uid: widget.idTutor).profile,
            builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('No Profile Data'));
              }

              final profile = snapshot.data!;

              return Container(
                color: wy,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: <Widget>[
                    ListTile(
                      title: Text('Phone Number', style: title),
                      subtitle: Text(profile.phoneNumber, style: info),
                    ),
                    ListTile(
                      title: Text('Bio', style: title),
                      subtitle: Text(profile.bio, style: info),
                    ),
                    ListTile(
                      title: Text('Address', style: title),
                      subtitle: Text(profile.address, style: info),
                    ),
                    ListTile(
                      title: Text('Education', style: title),
                      subtitle: Text(profile.education, style: info),
                    ),
                    ListTile(
                      title: Text('Experience', style: title),
                      subtitle: Text(profile.extraInfo, style: info),
                    ),
                  ],
                ),
              );
            },
          ),
          // Schedule
          Container(
            color: wy,
            padding: const EdgeInsets.only(top: 10),
            child: StreamBuilder<List<Schedule>>(
              stream: ScheduleDataService(uid: widget.idTutor).schedule,
              builder: (BuildContext context, AsyncSnapshot<List<Schedule>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No Schedule Data'));
                }

                final scheduleData = snapshot.data!;

                return ListView.builder(
                  itemCount: scheduleData.length,
                  itemBuilder: (context, index) {
                    final schedule = scheduleData[index];
                    String dayName;

                    switch (schedule.id) {
                      case "mon":
                        dayName = 'Monday';
                        break;
                      case "tue":
                        dayName = 'Tuesday';
                        break;
                      case "wed":
                        dayName = 'Wednesday';
                        break;
                      case "thu":
                        dayName = 'Thursday';
                        break;
                      case "fri":
                        dayName = 'Friday';
                        break;
                      case "sat":
                        dayName = 'Saturday';
                        break;
                      case "sun":
                        dayName = 'Sunday';
                        break;
                      default:
                        dayName = 'Unknown';
                    }

                    return TimelineTile(
                      beforeLineStyle: LineStyle(
                        color: bl,
                        thickness: 3,
                      ),
                      afterLineStyle: LineStyle(
                        color: bl,
                        thickness: 3,
                      ),
                      lineXY: 0,
                      indicatorStyle: IndicatorStyle(
                        color: schedule.id == dy.toLowerCase() ? yl : bl,
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        width: 13,
                        indicatorXY: 0.1,
                      ),
                      alignment: TimelineAlign.start,
                      endChild: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        color: yl,
                        child: Container(
                          padding: const EdgeInsets.only(left: 20, right: 30, top: 17, bottom: 30),
                          color: schedule.id == dy.toLowerCase() ? yl : wy,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 35,
                                child: Text(
                                  dayName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // Slot 1
                              _buildSlotContainer(
                                'Slot 1',
                                schedule.slot1 as String,
                                '(8am-10am)',
                              ),
                              // Slot 2
                              _buildSlotContainer(
                                'Slot 2',
                                schedule.slot2 as String,
                                '(10am-12pm)',
                              ),
                              // Slot 3
                              _buildSlotContainer(
                                'Slot 3',
                                schedule.slot3 as String,
                                '(3pm-5pm)',
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Book Session
          Container(
            color: wy,
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                      'Book a Session',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Select Day
                  DropdownButton<String>(
                    value: _scheduleDay.isNotEmpty ? _scheduleDay[sl] : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        sl = _scheduleDay.indexOf(newValue!);
                      });
                    },
                    items: _scheduleDay.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  // Select Date
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    child: TextFormField(
                      controller: TextEditingController(
                        text: DateFormat('yyyy-MM-dd').format(_bookDate),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _bookDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (selectedDate != null && selectedDate != _bookDate) {
                          setState(() {
                            _bookDate = selectedDate;
                          });
                        }
                      },
                    ),
                  ),
                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle submission
                      }
                    },
                    child: const Text('Book Now'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotContainer(String title, String slotValue, String timeRange) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: slotValue == 'Available' ? yl : bl,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$title $timeRange',
            style: TextStyle(
              color: slotValue == 'Available' ? wy : wy,
              fontSize: 16,
            ),
          ),
          Text(
            slotValue,
            style: TextStyle(
              color: slotValue == 'Available' ? wy : wy,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
