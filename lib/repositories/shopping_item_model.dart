import 'package:json_annotation/json_annotation.dart';

part 'shopping_item_model.g.dart';

enum Unit {
  Can,
  Bucket,
  Bag,
  Bottle,
  Jar,
  Gram,
  Kilogram,
  Box,
  Basket,
  Liter,
  Net,
  Package,
  Band,
  Piece
}

@JsonSerializable()
class ShoppingItem {
  final int id;
  final String creatorId;

  final String name;

  final String? description;

  final int quantity;

  final Unit unit;

  @JsonKey(defaultValue: false)
  final bool isBought;

  ShoppingItem(
      {required this.id,
      required this.creatorId,
      required this.name,
      this.description,
      required this.quantity,
      required this.unit,
      required this.isBought});

  factory ShoppingItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingItemToJson(this);
}
