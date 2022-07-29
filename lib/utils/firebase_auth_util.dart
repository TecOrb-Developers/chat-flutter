import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthUtil {
  final FirebaseAuth auth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;

  FirebaseAuthUtil({
    required this.auth,
    required this.firebaseFirestore,
    required this.prefs,
  });

  Stream<User?> get authState => auth.authStateChanges();

  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  User? get currentUser => auth.currentUser;

  bool _hasLoggedOut = false;

  bool get hasLoggedOut => _hasLoggedOut;

  //LOGIN WITH FACEBOOK
  Future<void> signInWithFb() async {
    try {
      // await signOut();

      final LoginResult loginResult = await FacebookAuth.instance.login();

      print("FB LOGIN RESULT STATUS: ${loginResult.status}");
      print("FB LOGIN RESULT MESSAGE: ${loginResult.message}");

      if (loginResult.accessToken?.token != null) {
        final OAuthCredential fbAuthCred =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        FacebookAuth.instance.getUserData();

        UserCredential userCredential =
            await auth.signInWithCredential(fbAuthCred);

        await saveToPrefs(userCredential.user!);

        print(userCredential);
      }
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

        User? user = (await auth.signInWithCredential(credential)).user;

        if (user != null) {
          DocumentSnapshot result = await firebaseFirestore
              .collection("user detail")
              .doc(user.uid)
              .get();

          if (result.exists) {
            _userModel =
                UserModel.fromMap(result.data() as Map<String, dynamic>);

            await saveToPrefs(user);
          } else {
            _userModel = UserModel(
              uid: user.uid,
              email: user.email,
              name: user.displayName,
              photoUrl: user.photoURL,
            );

            await firebaseFirestore
                .collection("user detail")
                .doc(user.uid)
                .set(_userModel?.toMap() ?? {})
                .then((value) => print("new user created..."));

            await firebaseFirestore.collection("location").doc(user.uid).set({
              "lat": "",
              "long": "",
              "name": user.displayName,
            }).then((value) => print("users list updated..."));

            await firebaseFirestore
                .collection("users")
                .doc(user.uid)
                .set(_userModel?.toMap() ?? {})
                .then((value) => print("users list updated..."));

            await saveToPrefs(user);
          }
        } else {
          print("authentication error");
        }

        print("\n$user");
      }
    } on FirebaseAuthException catch (e) {
      print(e.code.toString());
    }
  }

  Future<void> saveToPrefs(User user) async {
    // final prefs = await SharedPreferences.getInstance();

    print("user image: ${user.photoURL}");

    try {
      await prefs.setString(uidKey, user.uid);
      await prefs.setString(emailKey, user.email ?? "");
      await prefs.setString(nameKey, user.displayName ?? "");
      await prefs.setString(photoKey, user.photoURL ?? "");
      await prefs.setString(phoneKey, user.phoneNumber ?? "");

      print("pref image: ${prefs.getString(photoKey)}");
    } on Exception catch (e) {
      print(e);
    }
  }

  //SIGN OUT
  Future<bool> signOut() async {
    _hasLoggedOut = true;

    bool isClear = false;
    try {
      await auth.signOut().whenComplete(() async {
        print("LOGGED OUT SUCCESSFULLY");

        await GoogleSignIn()
            .disconnect()
            .then((value) => GoogleSignIn().signOut());

        _hasLoggedOut = false;
        isClear = await prefs.clear();
      });
      return isClear;
    } catch (e) {
      _hasLoggedOut = false;
      print(e);
      return isClear;
    }
  }
}
