import 'package:bops_mobile/src/utils/object_factory.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/state.dart';

class UserFirebaseProvider {
  /// login
  Future<State?> login() async {
    final UserCredential? userCredential =
        await ObjectFactory().firebaseClient.login();
    if (userCredential != null) {
      return State.success(userCredential);
    } else {
      return null;
    }
  }

/// sign out
Future<State?> signOut() async {
    try {
      await ObjectFactory()
          .firebaseClient
          .signOut(); 
      return State.success(
          "User signed out successfully"); 
    } catch (e) {
      return State.error(
          "Error during sign out: $e"); 
    }
  }
}
