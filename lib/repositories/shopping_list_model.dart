import 'package:flutter_project_2023/repositories/shopping_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shopping_list_model.g.dart';

@JsonSerializable()
class ShoppingList {
  final List<ShoppingItem> items;

  ShoppingList({required this.items});

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListToJson(this);
}
