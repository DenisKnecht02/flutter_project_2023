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

  getShoppingListStream(String groupId) {
    return db.collection(collectionId).doc(groupId).snapshots();
  }

  updateItem(String groupId, ShoppingItem item) async {
    await deleteItem(groupId, item.uuid);
    await addItem(groupId, item.name, item.description, item.createdDate,
        item.quantity, item.unit, item.state, item.uuid);
  }

  deleteItem(String groupId, String itemId) async {
    var docRef = db.collection(collectionId).doc(groupId);
    var snapshot = await docRef.get();
    var group = Group.fromFirestore(snapshot);

    var items = group.shoppingList.items
        .where((element) => element.uuid == itemId)
        .toList();

    Map<String, dynamic>? item;

    if (items.isNotEmpty) {
      item = items[0].toFirestore();

      try {
        await docRef.update({
          shoppingListField: FieldValue.arrayRemove([item])
        });
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  deleteItems(String groupId, List<DeleteItemsFilter> filter) async {
    if (filter.isEmpty) return;

    var docRef = db.collection(collectionId).doc(groupId);
    var snapshot = await docRef.get();
    var group = Group.fromFirestore(snapshot);

    List<ShoppingItem> items = [];
    for (var item in group.shoppingList.items) {
      for (var f in filter) {
        if (item.state.toString().split(".")[1] == f.toString().split(".")[1]) {
          items.add(item);
        }
      }
    }

    List<Map<String, dynamic>> firestoreItems = [];

    for (var item in items) {
      firestoreItems.add(item.toFirestore());
    }

    if (firestoreItems.isNotEmpty) {
      try {
        await docRef.update(
            {shoppingListField: FieldValue.arrayRemove(firestoreItems)});
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  addItem(
      String groupId,
      String name,
      String? description,
      Timestamp createdDate,
      double? quantity,
      Unit unit,
      ShoppingItemState state,
      [String? existingItemId]) async {
    var itemUuid = existingItemId ?? uuid.v4();
    var itemToAdd = ShoppingItem(
        uuid: itemUuid,
        creatorId: currentUser!.uid,
        createdDate: createdDate,
        name: name,
        description: description,
        quantity: quantity,
        unit: unit,
        state: state);

    try {
      await db.collection(collectionId).doc(groupId).update({
        shoppingListField: FieldValue.arrayUnion([itemToAdd.toFirestore()])
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
