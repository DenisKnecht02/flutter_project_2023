import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_project_2023/repositories/group_model.dart';
import 'package:flutter_project_2023/repositories/groups_model.dart';
import 'package:flutter_project_2023/repositories/shopping_list_model.dart';
import 'package:flutter_project_2023/shared/constants.dart';

class GroupRepository {
  final currentUser = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  createGroup(String name, String description) async {
    var group = Group("", currentUser!.uid, name, description, [currentUser!.uid], ShoppingList(items: []));
    db.collection(collectionId).add(group.toFirestore());
  }

  deleteGroup(String groupId) async {
    db.collection(collectionId).doc(groupId).delete();
  }

  Future<Groups> getGroups() async {

    List<Group> groups = [];
    await db
        .collection(collectionId)
        .where(userIdsField, arrayContainsAny: [currentUser?.uid])//TODO: add creator id condition
        .get()
        .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            groups.add(Group.fromFirestore(docSnapshot));
          }
        }, onError: (e) => throw Exception(e));

    return Groups(groups);
  }

  updateGroupInfo(String groupId, String name, String description) async{
        await db
        .collection(collectionId).doc(groupId).update({nameField: name, descriptionField: description})        
        .then((_) {}, onError: (e) => throw Exception(e));
  }

  removeUser(String groupId, String userId) async{
    await db
    .collection(collectionId).doc(groupId).update({userIdsField: FieldValue.arrayRemove([userId])})        
    .then((_) {}, onError: (e) => throw Exception(e));
  }

  addUser(String groupId, String userId) async{
    await db
    .collection(collectionId).doc(groupId).update({userIdsField: FieldValue.arrayUnion([userId])})        
    .then((_) {}, onError: (e) => throw Exception(e));
  }
  //TODO: Exception Handling

  
  Future<List<String>> getGroupNames() async {

    List<String> groupNames = [];
    await db
        .collection(collectionId)
        .where(userIdsField, arrayContainsAny: [currentUser?.uid])//TODO: add creator id condition
        .get()
        .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            groupNames.add(Group.fromFirestore(docSnapshot).name);
          }
        }, onError: (e) => throw Exception(e));

    return groupNames;
  }
}
