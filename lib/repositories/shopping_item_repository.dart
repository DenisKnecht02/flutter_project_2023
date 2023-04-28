import 'dart:convert';

import 'package:flutter_project_2023/repositories/shopping_item_model.dart';
import 'package:flutter_project_2023/repositories/shopping_list_model.dart';
import 'package:flutter_project_2023/shared/enums.dart';

class ShoppingItemRepository {
  Future<ShoppingList> getShoppingList() async {
    var shoppingList = ShoppingList(items: [
      ShoppingItem(
          id: 1,
          creatorId: "user#1",
          name: "Milch",
          quantity: 1,
          unit: Unit.Bottle,
          state: ShoppingItemState.Bought),
      ShoppingItem(
          id: 2,
          creatorId: "user#1",
          name: "Käse",
          quantity: 2,
          unit: Unit.Package,
          state: ShoppingItemState.NotBought),
      ShoppingItem(
          id: 2,
          creatorId: "user#2",
          name: "Käse",
          quantity: 2,
          unit: Unit.Package,
          state: ShoppingItemState.NotAvailable),
    ]);

    return shoppingList;
  }
}
