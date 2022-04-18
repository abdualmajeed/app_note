// ignore_for_file: unnecessary_new, prefer_const_constructors, avoid_single_cascade_in_expression_statements

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/auth/login.dart';
import 'package:note_app/home/home.dart';
import 'package:note_app/functions.dart/alert.dart';

class Signup extends StatefulWidget {
  static const String screenRoute = "signup";
  Signup({Key key}) : super(key: key);

  @override
  __SignupState createState() => __SignupState();
}

class __SignupState extends State<Signup> {
  // ignore: prefer_typing_uninitialized_variables
  var username, password, email;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  signUp() async {
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      formdata.save();

      try {
        showLoading(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        Navigator.of(context).pop();
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("password is too weak"))
            ..show();
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("The account already exists for that email"))
            ..show();
        }
      } catch (e) {
        print(e);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            body: SingleChildScrollView(
                child: Column(
      children: [
        Center(child: Image.asset("images/logo.png")),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Form(
              key: formstate,
              child: Column(
                children: [
                  TextFormField(
                      onSaved: (val) {
                        username = val;
                      },
                      validator: (val) {
                        if (val.length > 100) {
                          return "اسم المستخدم لايمكن ان يكون اكبر من 100 حرف";
                        }
                        if (val.length < 5) {
                          return "اسم المستخدم لايمكن ان يكون اصغر من 5 حرف";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "أدخل أسم المستخدم",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(20)),
                      )),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                      onSaved: (val) {
                        email = val;
                      },
                      validator: (val) {
                        if (val.length > 100) {
                          return "البريد الاليكتروني لايمكن ان يكون اكبر من 50 حرف";
                        }
                        if (val.length < 5) {
                          return "البريد الاليكتروني لايمكن ان يكون اصغر من 10 حرف";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "أدخل البريد الاليكتروني ",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(20)),
                      )),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                      onSaved: (val) {
                        password = val;
                      },
                      validator: (val) {
                        if (val.length > 100) {
                          return "كلمة المرور لايمكن ان يكون اكبر من 50 حرف";
                        }
                        if (val.length < 5) {
                          return "كلمة المرور لايمكن ان يكون اصغر من 5 حرف";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "أدخل كلمة المرور ",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(20)),
                      )),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("إذا تمتلك حساب"),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(Login.screenRoute);
                            },
                            child: Text("اضغط هنا"))
                      ],
                    ),
                  ),
                  Container(
                    child: MaterialButton(
                      onPressed: () async {
                        UserCredential response = await signUp();

                        if (response != null) {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .add({"username": username, "email": email});
                          Navigator.of(context)
                              .pushReplacementNamed(Homepage.screenRoute);
                        } else {
                          print("Faild");
                        }
                      }, 
                      child: Text(
                        "إنشاء الحساب",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      color: Colors.blue,
                    ),
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                ],
              )),
        )
      ],
    ))));
  }
}
