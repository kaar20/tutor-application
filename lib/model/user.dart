class User {
  final  uid;
  User({ this.uid});
}


class Appuser {
  final String uid;
  Appuser({required this.uid});

    User toUser() {
    return User(uid: uid);
  }

}
