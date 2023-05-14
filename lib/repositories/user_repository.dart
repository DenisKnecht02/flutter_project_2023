import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project_2023/shared/constants.dart';

class UserRepository {
  final db = FirebaseFirestore.instance;

  void registerUser(User user) async {
    db
        .collection(userCollectionId)
        .add({userIdField: user.uid, userNameField: user.displayName});
  }

  Future<void> changeDisplayName(String userId, String userName) async {
    var doc = await db
        .collection(userCollectionId)
        .where(userIdField, isEqualTo: userId)
        .get();
    if (doc.docs.length != 1) return;

    await db
        .collection(userCollectionId)
        .doc(doc.docs[0].id)
        .update({userNameField: userName});
    FirebaseAuth.instance.currentUser!.updateDisplayName(userName);
  }

  Future<String?> getUserNameById(String id) async {
    var snapshot = await db
        .collection(userCollectionId)
        .where(userIdField, isEqualTo: id)
        .get();
    if (snapshot.docs.length != 1) return null;
    return snapshot.docs[0].data()[userNameField];
  }

  Future<Map<String, String>> getUserByIds(List<String> ids) async {
    Map<String, String> userMap = {};

    for (var userId in ids) {
      try {
        var name = await getUserNameById(userId);
        userMap[userId] = name!;
      } catch (_) {
        continue;
      }
    }

    return userMap;
  }

  void deleteUser(String userId) async {
    var doc = await db
        .collection(userCollectionId)
        .where(userIdField, isEqualTo: userId)
        .get();
    if (doc.docs.length != 1) return;
    await db.collection(userCollectionId).doc(doc.docs[0].id).delete();
  }
}
