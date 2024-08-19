import '/model/user.dart';
import '/view/authenticate/authenticate.dart';
import '/view/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user.uid);

    if (user == null || user.uid=="") {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
