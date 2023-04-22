import 'dart:convert';

import 'package:flutter_project_2023/repositories/group_model.dart';
import 'package:flutter_project_2023/repositories/groups_model.dart';

class GroupRepository {
  Future<Groups> getGroups() async {
    var groups = Groups([
      Group(1, "group#1", "Familie HWR", null),
      Group(2, "group#2", "Familie Flutter", "Flutter Gruppe")
    ]);

    return groups;
  }
}
