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

  createGroup(String name, String description) async {
    var group = Group("", currentUser!.uid, name, description, [currentUser!.uid]);
    db.collection("groups").add(group.toFirestore());
  }

  deleteGroup(String groupId) async {
    db.collection("groups").doc(groupId).delete();
  }

  Future<Groups> getGroups() async {

    List<Group> groups = [];
    await db
        .collection(collectionId)
        .where("userIds", arrayContainsAny: [currentUser?.uid])
        .get()
        .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            groups.add(Group.fromFirestore(docSnapshot));
          }
        }, onError: (e) => throw Exception("Error"));
      
    return Groups(groups);
  }


}
