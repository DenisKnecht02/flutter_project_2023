import 'package:flutter_project_2023/repositories/shopping_item_model.dart';

import '../shared/enums.dart';

class ShoppingList {
  final List<ShoppingItem> items;

  ShoppingList({required this.items});

  factory ShoppingList.fromFirestore(List<dynamic> fetchedShoppingList) {
    List<ShoppingItem> shoppingList = [];

    for (var item in fetchedShoppingList) {
      double quantity = 0;

      if (item["quantity"] != null) {
        quantity = double.parse(item["quantity"].toString());
      }

      shoppingList.add(ShoppingItem(
        uuid: item?['uuid'],
        creatorId: item?['creatorId'],
        name: item?['name'],
        description: item?['description'],
        quantity: quantity,
        unit: Unit.values
            .firstWhere((e) => e.toString() == item?['unit'].toString()),
        state: ShoppingItemState.values
            .firstWhere((e) => e.toString() == item?['state'].toString()),
      ));
    }

    return ShoppingList(items: shoppingList);
  }

  List<Map<String, dynamic>> toFirestore() {
    List<Map<String, dynamic>> shoppingItems =
        items.map((e) => e.toFirestore()).toList();

    return shoppingItems;
  }
}
