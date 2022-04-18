// ignore_for_file: prefer_const_constructors, duplicate_ignore, curly_braces_in_flow_control_structures

import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:note_app/home/home.dart';
import 'package:note_app/functions.dart/alert.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNotes extends StatefulWidget {
  static const String screenRout = "addnote";
  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  CollectionReference noteref = FirebaseFirestore.instance.collection("notes");
  Reference ref;
  File file;
  var title, note, imgeurl;

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  addNote(context) async {
    // if (file == null || formstate.currentState.validate()==false )

    var formdata = formstate.currentState;
    if (formdata.validate() && file != null) {
      showLoading(context);
      formdata.save();
      await ref.putFile(file);
      imgeurl = await ref.getDownloadURL();
      await noteref.add({
        "title": title,
        "note": note,
        "imgeurl": imgeurl,
        "userid": FirebaseAuth.instance.currentUser.uid
      });

      Navigator.of(context).pushNamed(Homepage.screenRoute);
    } else if (file == null) {
      return AwesomeDialog(
          context: context,
          title: "تنبية",
          body: Text("الرجاء اختيار صورة"),
          dialogType: DialogType.ERROR)
        ..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('صفحة إضافة ملاحظة'),
      ),
      body: Container(
          child: Column(
        children: [
          Form(
              key: formstate,
              child: Column(
                children: [
                  TextFormField(
                    validator: (val) {
                      if (val.length > 30) {
                        return "عنوان الملاحظة لايمكن ان يكون اكبر من 30 حرف";
                      }
                      if (val.length < 5) {
                        return "عنوان الملاحظة لايمكن ان يكون اصغر من 5 أحرف";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      title = val;
                    },
                    maxLength: 60,
                    // ignore: prefer_const_constructors
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: " عنوان الملاحظة",
                      prefixIcon: Icon(Icons.note),
                    ),
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val.length > 30) {
                        return " الملاحظة لايمكن ان تكون اكبر من 500 حرف";
                      }
                      if (val.length < 5) {
                        return " الملاحظة لايمكن ان تكون اصغر من 10 أحرف";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      note = val;
                    },
                    minLines: 1,
                    maxLines: 4,
                    maxLength: 200,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: " الملاحظة",
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      showbottomsheet(context);
                    },
                    child: Text(
                      "أضف صورةالملاحظة",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    color: Colors.blue,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  MaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 5),
                    onPressed: () async {
                      await addNote(context);
                    },
                    child: Text(
                      "حفظ الملاحظة",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    color: Theme.of(context).buttonColor,
                  )
                ],
              ))
        ],
      )),
    );
  }

  showbottomsheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 250,
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "الرجاءإختيارالصورة",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Expanded(
                  child: InkWell(
                      onTap: () async {
                        var picked = await ImagePicker()
                            .getImage(source: ImageSource.gallery);
                        if (picked != null) {
                          file = File(picked.path);
                          var rand = Random().nextInt(100000);
                          var imgename = "$rand" + basename(picked.path);
                          ref = FirebaseStorage.instance
                              .ref("images")
                              .child("$imgename");
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 220),
                        // width: double.infinity,
                        child: Row(
                          children: const [
                            Text(
                              "فتح المعرض",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Icon(Icons.photo),
                          ],
                        ),
                      )),
                ),
                Expanded(
                    child: InkWell(
                        onTap: () async {
                          var picked = await ImagePicker()
                              .getImage(source: ImageSource.camera);
                          if (picked != null) {
                            file = File(picked.path);
                            var rand = Random().nextInt(100000);
                            var imgename = "$rand" + basename(picked.path);
                            ref = FirebaseStorage.instance
                                .ref("images")
                                .child("$imgename");
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          // width: double.infinity,
                          margin: EdgeInsets.only(left: 220),
                          child: Row(
                            children: [
                              Text(
                                "فتح الكاميرا",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Icon(Icons.camera),
                            ],
                          ),
                        ))),
              ],
            ),
          );
        });
  }
}
