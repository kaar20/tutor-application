import '/model/user.dart' as  app_model;
import 'package:firebase_auth/firebase_auth.dart';

import 'evaluatedata.dart';
import 'feeddata.dart';
import 'profiledata.dart';
import 'ratedata.dart';
import 'scheduledata.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create AppUser object based on Firebase User
  app_model.Appuser? _userFromFirebaseUser(User? user) {
    return user != null ? app_model.Appuser(uid: user.uid) : null;
  }

  // auth user change stream
  Stream<app_model.Appuser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in anon
  Future<app_model.Appuser?> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in email & password
  Future<app_model.Appuser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register email & password
  Future<app_model.Appuser?> registerWithEmailAndPassword(
      bool usertype, String name, String phone, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // create user's main details
      await ProfileDataService(uid: user!.uid).createProfileData(usertype, name, phone);

      // create tutor schedule
      if (usertype) {
        await ScheduleDataService(uid: user.uid).createScheduleData();
        await FeedDataService(uid: user.uid).createFeedbackData();
        await RateDataService(uid: user.uid).createRateData();
      } else {
        await EvaluateDataService(uid: user.uid).createEvaluationData();
      }

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
