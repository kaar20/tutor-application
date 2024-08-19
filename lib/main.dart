import 'package:firebase_core/firebase_core.dart';
import '/controller/auth.dart';
import '/model/user.dart';
import '/view/authenticate/authenticate.dart';
import '/view/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

  void main() async{  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
value: AuthService().user.map((Appuser? user) => user?.toUser() ?? User(uid: '')),            initialData: User(uid: ''), // Provide an initial User object here

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        //home: Authenticate(),
      ),
    );
  }
}
