import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_project/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthUtil {
  final FirebaseAuth _auth;

  FirebaseAuthUtil(this._auth);

  Stream<User?> get authState => _auth.authStateChanges();

  //LOGIN WITH FACEBOOK
  Future<void> signInWithFb() async {
    try {
      // await signOut();

      final LoginResult loginResult = await FacebookAuth.instance.login();

      print("FB LOGIN RESULT STATUS: ${loginResult.status}");
      print("FB LOGIN RESULT MESSAGE: ${loginResult.message}");

      // if (loginResult.accessToken?.token != null) {
      final OAuthCredential fbAuthCred =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      UserCredential userCredential =
          await _auth.signInWithCredential(fbAuthCred);

      // await saveToPrefs(userCredential);

      print(userCredential);
      // }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  //LOGIN WITH GOOGLE
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      print("$googleUser\n");

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        await saveToPrefs(userCredential);

        print("\n$userCredential");
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<void> saveToPrefs(UserCredential userCredential) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      await prefs.setString(uidKey, userCredential.user?.uid ?? "");
      await prefs.setString(emailKey, userCredential.user?.email ?? "");
      await prefs.setString(nameKey, userCredential.user?.displayName ?? "");
      await prefs.setString(photoKey, userCredential.user?.photoURL ?? "");
      await prefs.setString(phoneKey, userCredential.user?.phoneNumber ?? "");
    } on Exception catch (e) {
      print(e);
    }
  }

  //SIGN OUT
  Future<void> signOut() async {
    try {
      await _auth
          .signOut()
          .whenComplete(() => print("LOGGED OUT SUCCESSFULLY"));

      // await _auth.currentUser?.delete().whenComplete(
      //     () => print("LOGGED OUT SUCCESSFULLY\nAND DELETED THE ACCOUNT"));
    } catch (e) {
      print(e);
    }
  }
}
