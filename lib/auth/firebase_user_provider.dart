import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class VelhomeFirebaseUser {
  VelhomeFirebaseUser(this.user);
  User user;
  bool get loggedIn => user != null;
}

VelhomeFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<VelhomeFirebaseUser> velhomeFirebaseUserStream() => FirebaseAuth.instance
    .authStateChanges()
    .debounce((user) => user == null && !loggedIn
        ? TimerStream(true, const Duration(seconds: 1))
        : Stream.value(user))
    .map<VelhomeFirebaseUser>(
        (user) => currentUser = VelhomeFirebaseUser(user));
