// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      json['id'] as String,
      json['creatorId'] as String,
      json['name'] as String,
      json['description'] as String?,
      (json['userIds'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'name': instance.name,
      'description': instance.description,
      'userIds': instance.userIds,
    };
