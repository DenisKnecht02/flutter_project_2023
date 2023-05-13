import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project_2023/repositories/group_model.dart';
import 'package:flutter_project_2023/repositories/shopping_list_model.dart';

class Groups {
  final List<Group> groups;

  Groups(this.groups);

  factory Groups.fromFirestoreStream(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshot) {
    final List<Group> groups = [];

    for (var rawGroup in snapshot) {
      final data = rawGroup.data();
      final group = Group(
        rawGroup.id,
        data['creatorId'],
        data['name'],
        data['description'],
        data['userIds'] is Iterable
            ? List.from(data['userIds'])
            : throw Exception("error"),
        ShoppingList.fromFirestore(data['shoppingList'] as List),
      );
      groups.add(group);
    }
    return Groups(groups);
  }
}
