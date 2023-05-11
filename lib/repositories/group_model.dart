import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project_2023/repositories/shopping_item_model.dart';
import 'package:flutter_project_2023/repositories/shopping_list_model.dart';

import '../shared/enums.dart';

class Group {
  final String id;

  final String creatorId;

  final String name;

  final String? description;

  final List<String> userIds;

  final ShoppingList shoppingList;
  //TODO: List as ShoppingList
  
  Group(this.id, this.creatorId, this.name, this.description, this.userIds, this.shoppingList);

  factory Group.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();

    List<ShoppingItem> shoppingList = [];

    for (var item in data?['shoppingList'] as List) {

      shoppingList.add(ShoppingItem(
        uuid: item?['uuid'],
        creatorId: item?['creatorId'],
        name: item?['name'],
        description: item?['description'],
        quantity: item?['quantity'],
        unit: Unit.values.firstWhere((e) => e.toString() == item?['unit'].toString()),
        state: ShoppingItemState.values.firstWhere((e) => e.toString() == item?['state'].toString()),
      ));
    }

    return Group(
        snapshot.id,
        data?['creatorId'],
        data?['name'],
        data?['description'],
        data?['userIds'] is Iterable
            ? List.from(data?['userIds'])
            : throw Exception("error"),
        ShoppingList(items: shoppingList),
        );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "creatorId": creatorId,
      "name": name,
      "description": description,
      "userIds": userIds,
      "shoppingList": shoppingList
    };
  }
}
