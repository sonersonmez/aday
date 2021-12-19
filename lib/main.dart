import 'package:aday/views/login_screen.dart';
import 'package:aday/views/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
     User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: applicationTitle,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: user!=null ? MainScreen() : LoginScreen() ,
    );
  }
}

