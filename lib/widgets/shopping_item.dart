import 'package:flutter/material.dart';
import 'package:flutter_project_2023/repositories/shopping_item_model.dart';

class ShoppingItemWidget extends StatelessWidget {
  final ShoppingItem shoppingItem;

  const ShoppingItemWidget(this.shoppingItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text(shoppingItem.name),
          subtitle: Text(
              "${shoppingItem.description ?? ''} (by: ${shoppingItem.creatorId})"),
          leading:
              Icon(shoppingItem.isBought ? Icons.check : Icons.question_mark),
        ),
      ),
    );
  }
}
