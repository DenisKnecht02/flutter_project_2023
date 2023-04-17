// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingItem _$ShoppingItemFromJson(Map<String, dynamic> json) => ShoppingItem(
      id: json['id'] as int,
      creatorId: json['creatorId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      quantity: json['quantity'] as int,
      unit: $enumDecode(_$UnitEnumMap, json['unit']),
      isBought: json['isBought'] as bool? ?? false,
    );

Map<String, dynamic> _$ShoppingItemToJson(ShoppingItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'name': instance.name,
      'description': instance.description,
      'quantity': instance.quantity,
      'unit': _$UnitEnumMap[instance.unit]!,
      'isBought': instance.isBought,
    };

const _$UnitEnumMap = {
  Unit.Can: 'Can',
  Unit.Bucket: 'Bucket',
  Unit.Bag: 'Bag',
  Unit.Bottle: 'Bottle',
  Unit.Jar: 'Jar',
  Unit.Gram: 'Gram',
  Unit.Kilogram: 'Kilogram',
  Unit.Box: 'Box',
  Unit.Basket: 'Basket',
  Unit.Liter: 'Liter',
  Unit.Net: 'Net',
  Unit.Package: 'Package',
  Unit.Band: 'Band',
  Unit.Piece: 'Piece',
};
