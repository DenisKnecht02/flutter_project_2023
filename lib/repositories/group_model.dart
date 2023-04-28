import 'package:json_annotation/json_annotation.dart';

part 'group_model.g.dart';

@JsonSerializable()
class Group {
  final int id;
  final String creatorId;

  final String name;

  final String? description;

  final List<String> userIds;

  Group(this.id, this.creatorId, this.name, this.description, this.userIds);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
