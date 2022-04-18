// ignore_for_file: prefer_const_constructors, avoid_single_cascade_in_expression_statements, unused_local_variable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/auth/signup.dart';
import 'package:note_app/home/home.dart';
import 'package:note_app/functions.dart/alert.dart';

class Login extends StatefulWidget {
  static const String screenRoute = "login";
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // ignore: prefer_typing_uninitialized_variables
  var password, email;
  bool pass = true;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  signin() async {
    var formdata = formstate.currentState;
    if (formdata.validate()) {
      formdata.save();
      try {
        showLoading(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        Navigator.of(context).pop();
        return Navigator.of(context).pushReplacementNamed(Homepage.screenRoute);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("No user found for that email."))
            ..show();
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("Wrong password provided for that user."))
            ..show();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset("images/logo.png")),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: formstate,
                child: Column(
                  children: [
                    TextFormField(
                        onSaved: (val) {
                          email = val;
                        },
                        validator: (val) {
                          if (val.length > 100) {
                            return "البريد الاليكتروني لايمكن ان يكون اكبر من 50 حرف";
                          }
                          if (val.length < 5) {
                            return "كلمة المرور لايمكن ان تكون اصغر من 10 حرف";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "أدخل الإيميل ",
                          hintStyle: TextStyle(color: Colors.green[800]),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.orange,
                          ),
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
                            return "كلمة المرور لايمكن ان تكون اصغر من 5 حرف";
                          }
                          return null;
                        },
                        obscureText: pass,
                        decoration: InputDecoration(
                          hintText: "أدخل كلمة المرور ",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.orange,
                          ),
                          suffix: Container(
                            height: 20,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (pass == true) {
                                      pass = false;
                                    } else if (pass == false) {
                                      pass = true;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.password_rounded,
                                  size: 15,
                                )),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 2),
                              borderRadius: BorderRadius.circular(20)),
                        )),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("إذا لاتمتلك حساب"),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Signup.screenRoute);
                              },
                              child: Text("اضغط هنا"))
                        ],
                      ),
                    ),
                    Container(
                      child: MaterialButton(
                        color: Theme.of(context).buttonColor,
                        onPressed: () async {
                          await signin();
                        },
                        child: Text(
                          "تسجيل الدخول",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      padding: EdgeInsets.only(top: 15.0),
                    ),
                  ],
                )),
          )
        ],
      ),
    ));
  }
}
