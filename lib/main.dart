import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_project/screens/NoInternetScreen.dart';
import 'package:new_project/screens/onboarding_screen_1.dart';
import 'package:new_project/screens/share_location_screen.dart';
import 'package:new_project/screens/splash_screen.dart';
import 'package:new_project/utils/firebase_auth_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.prefs}) : super(key: key);

  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
            create: (_) => FirebaseAuthUtil(
                  auth: FirebaseAuth.instance,
                  firebaseFirestore: firebaseFirestore,
                  prefs: prefs,
                )),
        // StreamProvider(
        //   create: (_) => context.read<FirebaseAuthUtil>().authState,
        //   initialData: null,
        // ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Timer(
      const Duration(milliseconds: 2200),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.watch<FirebaseAuthUtil>().authState,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const ShareLocationScreen();
          } else if (snapshot.hasError) {
            return const NoInternetScreen();
          }
          return const OnboardingScreen();
        });
  }
}
