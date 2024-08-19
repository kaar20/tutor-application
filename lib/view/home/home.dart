import '/controller/profiledata.dart';
import '/model/profile.dart';
import '/model/user.dart';
import '/view/home/users/homewrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // print(user.uid);

    return StreamProvider<Profile>.value(
      value: ProfileDataService(uid: user.uid).profile,
catchError: (_, __) => Profile(uid: '', fullName: '', phoneNumber: '', type: false, bio: '', address: '', education: '', extraInfo: '', image: '', exam: '', subject: [], price: 0), initialData: Profile(uid: '', fullName: '', phoneNumber: '', type: false, bio: '', address: '', education: '', extraInfo: '', image: '', exam: '', subject: [], price: 0),
      child: MaterialApp(
        home: HomeWrapper(),
      ),   );
  }
}
