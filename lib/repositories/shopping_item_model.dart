import 'package:flutter_project_2023/shared/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shopping_item_model.g.dart';

@JsonSerializable()
class ShoppingItem {
  final int id;
  final String creatorId;

  final String name;

  final String? description;

  final int quantity;

  final Unit unit;

  @JsonKey(defaultValue: ShoppingItemState.NotBought)
  ShoppingItemState state;

  ShoppingItem(
      {required this.id,
      required this.creatorId,
      required this.name,
      this.description,
      required this.quantity,
      required this.unit,
      required this.state});

  factory ShoppingItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingItemToJson(this);
}
