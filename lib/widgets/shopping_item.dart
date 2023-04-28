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
        boxColor = Colors.green[100]!;
        break;
      case ShoppingItemState.NotBought:
        boxColor = Colors.white;
        break;
      case ShoppingItemState.NotAvailable:
        boxColor = Colors.grey[300]!;
        break;
      default:
        boxColor = Colors.white;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: boxColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            blurRadius: 4.0,
            offset: const Offset(2.0, 2.0),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          widget.shoppingItem.name,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "${widget.shoppingItem.description ?? ''} (by: ${widget.shoppingItem.creatorId})",
            style: const TextStyle(fontSize: 14.0),
          ),
        ),
        leading: Icon(
          getStateIconData(widget.shoppingItem.state),
          color: _getIconColor(widget.shoppingItem.state),
          size: 28.0,
        ),
        trailing: PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case 'delete':
                // handle delete action
                break;
              case 'Edit':
                // handle Edit action
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
            const PopupMenuItem(
              value: 'Edit',
              child: Text('Edit'),
            ),
          ],
          icon: _meatballMenuIcon,
        ),
        onTap: () {
          setState(() {
            widget.shoppingItem.state = ShoppingItemState.values[
                (widget.shoppingItem.state.index + 1) %
                    ShoppingItemState.values.length];
          });
        },
      ),
    );
  }

  Color _getIconColor(ShoppingItemState state) {
    switch (state) {
      case ShoppingItemState.Bought:
        return Colors.green;
      case ShoppingItemState.NotBought:
        return Colors.blue;
      case ShoppingItemState.NotAvailable:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}

IconData getStateIconData(ShoppingItemState state) {
  switch (state) {
    case ShoppingItemState.Bought:
      return Icons.check_circle;
    case ShoppingItemState.NotBought:
      return Icons.shopping_cart;
    case ShoppingItemState.NotAvailable:
      return Icons.remove_shopping_cart;
    default:
      return Icons.help_outline;
  }
}
