import 'package:flutter_project_2023/repositories/group_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'groups_model.g.dart';

@JsonSerializable()
class Groups {
  final List<Group> groups;

  Groups(this.groups);

  factory Groups.fromJson(Map<String, dynamic> json) => _$GroupsFromJson(json);

  Map<String, dynamic> toJson() => _$GroupsToJson(this);
}
