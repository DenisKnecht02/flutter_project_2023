import 'package:flutter/material.dart';
import 'package:flutter_project_2023/shared/enums.dart';
import 'package:flutter_project_2023/repositories/shopping_item_model.dart';

class ShoppingItemWidget extends StatefulWidget {
  final ShoppingItem shoppingItem;

  ShoppingItemWidget({Key? key, required this.shoppingItem}) : super(key: key);

  @override
  _ShoppingItemWidgetState createState() => _ShoppingItemWidgetState();
}

class _ShoppingItemWidgetState extends State<ShoppingItemWidget> {
  final _meatballMenuIcon = const Icon(Icons.more_vert);

  @override
  Widget build(BuildContext context) {
    Color boxColor;
    switch (widget.shoppingItem.state) {
      case ShoppingItemState.Bought:
        boxColor = Colors.green;
        break;
      case ShoppingItemState.NotBought:
        boxColor = Colors.white;
        break;
      case ShoppingItemState.NotAvailable:
        boxColor = Colors.grey;
        break;
      default:
        boxColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: boxColor,
        child: ListTile(
          title: Text(widget.shoppingItem.name),
          subtitle: Text(
              "${widget.shoppingItem.description ?? ''} (by: ${widget.shoppingItem.creatorId})"),
          leading: Icon(getStateIconData(widget.shoppingItem.state)),
          trailing: PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 'delete':
                  // handle delete action
                  break;
                case 'Update':
                  // handle Update action
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
              const PopupMenuItem(
                value: 'Update',
                child: Text('Update'),
              ),
            ],
          ),
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
