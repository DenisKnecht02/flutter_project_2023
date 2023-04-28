import 'dart:convert';

import 'package:flutter_project_2023/repositories/group_model.dart';
import 'package:flutter_project_2023/repositories/groups_model.dart';

class GroupRepository {
  Future<Groups> getGroups() async {
    var groups = Groups([
      Group(
          1, "user#1", "Wohnung Berlin", null, ["user#1", "user#2", "user#3"]),
      Group(2, "user#2", "WG Köln", "WG Gruppe in Köln",
          ["user#1", "user#2", "user#3"]),
      Group(3, "user#3", "Großeltern München", null,
          ["user#1", "user#2", "user#3"]),
    ]);

    return groups;
  }
}
