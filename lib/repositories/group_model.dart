import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String id;

  final String creatorId;

  final String name;

  final String? description;

  final List<String> userIds;

  Group(this.id, this.creatorId, this.name, this.description, this.userIds);

  factory Group.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Group(
        snapshot.id,
        data?['creatorId'],
        data?['name'],
        data?['description'],
        data?['userIds'] is Iterable
            ? List.from(data?['userIds'])
            : throw Exception("error"));
  }

  Map<String, dynamic> toFirestore() {
    return {
      "creatorId": creatorId,
      "name": name,
      "description": description,
      "userIds": userIds,
    };
  }

}
