// ignore_for_file: missing_return, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/auth/login.dart';
import 'package:note_app/crud/addnote.dart';

class Homepage extends StatefulWidget {
  static const String screenRoute = "home";
  const Homepage({Key key}) : super(key: key);
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CollectionReference noteref = FirebaseFirestore.instance.collection("notes");

  getuser() {
    var user = FirebaseAuth.instance.currentUser;
    var useremail = user.email;
    return useremail;
  }

  var fm = FirebaseMessaging.instance;

  @override
  void initState() {
    getuser();
    fm.getToken().then((value) {
      print("=================");
      print(value);
      print("=======================");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed(Login.screenRoute);
                },
                icon: Icon(Icons.exit_to_app)),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('الصفحة الرئيسية'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(AddNotes.screenRout);
          },
          backgroundColor: Theme.of(context).buttonColor,
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                  currentAccountPicture:
                      CircleAvatar(child: Icon(Icons.person)),
                  accountName: Icon(Icons.email),
                  accountEmail: Text(getuser().toString())),
              ListTile(
                title: Text(
                  "الإعدادات",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                leading: Icon(Icons.settings),
              )
            ],
          ),
        ),
        body: Container(
          child: FutureBuilder(
            future: noteref
                .where("userid",
                    isEqualTo: FirebaseAuth.instance.currentUser.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return ListNotes(
                        notes: snapshot.data.docs[index],
                      );
                    });
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

class ListNotes extends StatelessWidget {
  final notes;
  ListNotes({this.notes});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Image.network(
              "${notes['imgeurl']}",
              height: 100,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            flex: 3,
            child: ListTile(
              title: Text("${notes['title']}"),
              subtitle: Text(
                "${notes['note']}",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              trailing: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
            ),
          ),
        ],
      ),
    );
  }
}
