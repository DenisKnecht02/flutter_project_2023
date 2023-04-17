import 'package:flutter/material.dart';
import 'package:flutter_project_2023/repositories/shopping_item_repository.dart';
import 'package:flutter_project_2023/widgets/shopping_item.dart';

class ShoppingListPage extends StatelessWidget {
  ShoppingItemRepository shoppingListRepository = new ShoppingItemRepository();

  ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: shoppingListRepository.getShoppingList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: snapshot.data?.items
                        .map((item) => ShoppingItemWidget(shoppingItem: item))
                        .toList() ??
                    [],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
