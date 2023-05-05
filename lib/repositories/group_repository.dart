import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_project_2023/repositories/group_model.dart';
import 'package:flutter_project_2023/repositories/groups_model.dart';

class GroupRepository {
  final firestore = FirebaseFirestore.instance;
  List<Group> groupsList = [];

  Future<Groups> getGroups() async {

    var groups2 = firestore.collection("/groups");

    await groups2.get()
    .then((querySnapshot) {
      debugPrint("##############");
        for (var docSnapshot in querySnapshot.docs) {
          
          final data = docSnapshot.data();

          for (var test in data.values) {
            groupsList.add(test);
          }
        }
      },
      onError: (e) => debugPrint("Error completing: $e")
    );

    return Groups([
      Group(1, "group#1", "Familie HWR", null),
      Group(2, "group#2", "Familie Flutter", "Flutter Gruppe")
    ]);

  }
}
