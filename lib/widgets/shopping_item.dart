import 'package:flutter/material.dart';
import 'package:flutter_project_2023/shared/enums.dart';
import 'package:flutter_project_2023/repositories/shopping_item_model.dart';

class ShoppingItemWidget extends StatefulWidget {
  ShoppingItem shoppingItem;

  ShoppingItemWidget({super.key, required this.shoppingItem});

  @override
  State<ShoppingItemWidget> createState() => _ShoppingItemWidgetState();
}

class _ShoppingItemWidgetState extends State<ShoppingItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: shoppingItem.isBought ? Colors.green : null,
        child: ListTile(
          title: Text(widget.shoppingItem.name),
          subtitle: Text(
              "${widget.shoppingItem.description ?? ''} (by: ${widget.shoppingItem.creatorId})"),
          leading: Icon(getStateIconData(widget.shoppingItem.state)),
          onTap: () {
            setState(() {
              widget.shoppingItem.state = ShoppingItemState.values[
                  (widget.shoppingItem.state.index + 1) %
                      ShoppingItemState.values.length];
            });
          },
        ),
      ),
    );
  }
}

IconData getStateIconData(ShoppingItemState state) {
  IconData iconData;
  switch (state) {
    case ShoppingItemState.Bought:
      iconData = Icons.check;
      break;
    case ShoppingItemState.NotBought:
      iconData = Icons.shopping_cart;
      break;
    case ShoppingItemState.NotAvailable:
      iconData = Icons.remove_shopping_cart;
      break;
    default:
      iconData = Icons.question_mark;
  }

  return iconData;
}
