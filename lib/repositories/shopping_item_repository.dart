import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project_2023/repositories/shopping_item_model.dart';
import 'package:flutter_project_2023/repositories/shopping_list_model.dart';
import 'package:flutter_project_2023/shared/enums.dart';
import 'package:uuid/uuid.dart';
import '../shared/constants.dart';
import 'group_model.dart';

class ShoppingItemRepository {
  final uuid = Uuid();
  final currentUser = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  Future<ShoppingList> getShoppingList(String groupId) async {
    return await db.collection(collectionId).doc(groupId).get().then(
        (querySnapshot) {
      var group = Group.fromFirestore(querySnapshot);
      return group.shoppingList;
    }, onError: (e) => throw Exception(e));
  }

  updateItem(String groupId, ShoppingItem existingItem,
      ShoppingItem itemToCreate) async {
    deleteItem(groupId, existingItem);
    addItem(
        groupId,
        itemToCreate.name,
        itemToCreate.description,
        itemToCreate.quantity,
        itemToCreate.unit,
        itemToCreate.state,
        existingItem.uuid);
  }

  deleteItem(String groupId, ShoppingItem shoppingItem) async {
    await db.collection(collectionId).doc(groupId).update({
      shoppingListField: FieldValue.arrayRemove([shoppingItem.toFirestore()])
    }).then((_) {}, onError: (e) => throw Exception(e));
  }

  addItem(String groupId, String name, String? description, double? quantity,
      Unit unit, ShoppingItemState state,
      [String? existingItemId]) async {
    var itemUuid = existingItemId ?? uuid.v4();
    var itemToAdd = ShoppingItem(
        uuid: itemUuid,
        creatorId: currentUser!.uid,
        name: name,
        description: description,
        quantity: quantity,
        unit: unit,
        state: state);

    await db.collection(collectionId).doc(groupId).update({
      shoppingListField: FieldValue.arrayUnion([itemToAdd.toFirestore()])
    }).then((_) {}, onError: (e) => throw Exception(e));
  }
}
