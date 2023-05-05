import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_project_2023/repositories/group_model.dart';
import 'package:flutter_project_2023/repositories/groups_model.dart';
import 'package:flutter_project_2023/shared/constants.dart';

class GroupRepository {
  final currentUser = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  Future<Groups> getGroups() async {
    var groups = List<Group>;
    await db
        .collection(collectionId)
        .where("userIds", arrayContainsAny: ["Eqo0JFfEDwdiUPDw78y1UYS5LGb2"])
        .get()
        .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            print('${docSnapshot.id} => ${docSnapshot.data()}');
            print(Group.fromFirestore(docSnapshot));
            groups.add
          }
        }, onError: (e) => throw Exception("Error"));
  }

  void request() async {
    debugPrint("called!");
    await db
        .collection(collectionId)
        .where("userIds", arrayContainsAny: ["Eqo0JFfEDwdiUPDw78y1UYS5LGb2"])
        .get()
        .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            print('${docSnapshot.id} => ${docSnapshot.data()}');
            print(Group.fromFirestore(docSnapshot));
          }
        }, onError: (e) => throw Exception("Error"));
  }
}
