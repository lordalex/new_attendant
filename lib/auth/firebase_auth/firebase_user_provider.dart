import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../base_auth_user_provider.dart';

export '../base_auth_user_provider.dart';

/// Validates the current Firebase session by forcing a token refresh.
/// Returns true if valid, false if invalid (user deleted, token expired, etc.)
/// Auto signs out if the session is invalid.
Future<bool> validateFirebaseSession() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return false;
  }

  try {
    // Force token refresh - this will fail if user is deleted or disabled
    await user.getIdToken(true);
    // Reload user to check if account still exists
    await user.reload();
    return true;
  } catch (e) {
    print('Session validation failed: $e');
    // Invalid session - sign out
    await FirebaseAuth.instance.signOut();
    return false;
  }
}

class KnexattendantFirebaseUser extends BaseAuthUser {
  KnexattendantFirebaseUser(this.user);
  User? user;
  @override
  bool get loggedIn => user != null;

  @override
  AuthUserInfo get authUserInfo => AuthUserInfo(
        uid: user?.uid,
        email: user?.email,
        displayName: user?.displayName,
        photoUrl: user?.photoURL,
        phoneNumber: user?.phoneNumber,
      );

  @override
  Future? delete() => user?.delete();

  @override
  Future? updateEmail(String email) async {
    await user?.verifyBeforeUpdateEmail(email);
  }

  @override
  Future? updatePassword(String newPassword) async {
    await user?.updatePassword(newPassword);
  }

  @override
  Future? sendEmailVerification() => user?.sendEmailVerification();

  @override
  bool get emailVerified {
    // Reloads the user when checking in order to get the most up to date
    // email verified status.
    if (loggedIn && !user!.emailVerified) {
      refreshUser();
    }
    return user?.emailVerified ?? false;
  }

  @override
  Future refreshUser() async {
    await FirebaseAuth.instance.currentUser
        ?.reload()
        .then((_) => user = FirebaseAuth.instance.currentUser);
  }

  static BaseAuthUser fromUserCredential(UserCredential userCredential) =>
      fromFirebaseUser(userCredential.user);
  static BaseAuthUser fromFirebaseUser(User? user) =>
      KnexattendantFirebaseUser(user);
}

Stream<BaseAuthUser> knexattendantFirebaseUserStream() => FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<BaseAuthUser>(
      (user) {
        currentUser = KnexattendantFirebaseUser(user);
        return currentUser!;
      },
    );
