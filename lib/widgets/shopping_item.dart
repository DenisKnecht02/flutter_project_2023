import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_2023/repositories/shopping_item_repository.dart';
import 'package:flutter_project_2023/shared/enums.dart';
import 'package:flutter_project_2023/repositories/shopping_item_model.dart';

class ShoppingItemWidget extends StatefulWidget {
  final String groupId;
  final ShoppingItem shoppingItem;

  ShoppingItemWidget(
      {Key? key, required this.shoppingItem, required this.groupId})
      : super(key: key);

  @override
  _ShoppingItemWidgetState createState() => _ShoppingItemWidgetState();
}

class _ShoppingItemWidgetState extends State<ShoppingItemWidget> {
  final _meatballMenuIcon = const Icon(Icons.more_vert);

  ShoppingItemRepository shoppingListRepository = ShoppingItemRepository();

  String productName = "";
  String productDescription = "";
  double productQuantity = 0;

  Unit? _selectedUnit;

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
          "${widget.shoppingItem.quantity}x ${widget.shoppingItem.name}",
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Delete Item'),
                    content: const Text(
                        'Are you sure you want to delete this item?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // delete the item from the list
                          shoppingListRepository.deleteItem(
                              widget.groupId, widget.shoppingItem.uuid);

                          Navigator.pop(context);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                break;
              case 'Edit':
                AlertDialog(
                  title: const Text("Edit an Item"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Enter product name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        onChanged: (value) {
                          productName = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Enter product description',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        onChanged: (value) {
                          productDescription = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                productQuantity = double.parse(value);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              child: DropdownButton<Unit>(
                                onChanged: (Unit? newValue) {
                                  setState(() {
                                    _selectedUnit = newValue;
                                  });
                                },
                                value: _selectedUnit,
                                items: Unit.values.map((Unit unit) {
                                  return DropdownMenuItem<Unit>(
                                    value: unit,
                                    child: Text(
                                      unit.toString().split('.').last,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                style: const TextStyle(color: Colors.black),
                                hint: const Text(
                                  'Select a Unit',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                underline: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.black,
                                ),
                                iconSize: 24,
                                iconEnabledColor: Colors.black,
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                elevation: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        if (_selectedUnit == null) {
                          // TODO: Error Handling
                          return;
                        }
                        /*
                        shoppingListRepository.updateItem(
                            widget.groupId,
                            productName,
                            productDescription,
                            productQuantity,
                            _selectedUnit!,
                            ShoppingItemState.NotBought);
                        */
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 4.0,
                );
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
            var newItem = widget.shoppingItem.copy();
            newItem.state = ShoppingItemState.values[
                (newItem.state.index + 1) % ShoppingItemState.values.length];
            shoppingListRepository.updateItem(widget.groupId, newItem);
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
