// import 'package:firebase_core/firebase_core.dart';
// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/crud/addnote.dart';
import 'package:note_app/home/home.dart';
import 'package:flutter/material.dart';
import 'package:note_app/auth/login.dart';
import 'package:note_app/auth/signup.dart';
import 'package:firebase_core/firebase_core.dart';

bool islogedin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    islogedin = false;
  } else {
    islogedin = true;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: islogedin == false ? Login() : Homepage(),
      theme: ThemeData(
          primaryColor: Colors.orange,
          buttonColor: Colors.green[500],
          textTheme: const TextTheme(
              headline6: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ))),
      routes: {
        Login.screenRoute: (context) => Login(),
        Signup.screenRoute: (context) => Signup(),
        Homepage.screenRoute: (context) => Homepage(),
        AddNotes.screenRout: (context) => AddNotes(),
      },
    );
  }
}
