import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_2023/repositories/shopping_item_repository.dart';
import 'package:flutter_project_2023/shared/enums.dart';

class ShoppingListAddItem extends StatefulWidget {
  const ShoppingListAddItem({Key? key, required this.groupId})
      : super(key: key);

  final String groupId;

  @override
  _ShoppingListAddItemState createState() => _ShoppingListAddItemState();
}

class _ShoppingListAddItemState extends State<ShoppingListAddItem> {
  String productName = "";
  String productDescription = "";
  double productQuantity = 0;

  Unit? _selectedUnit;
  ShoppingItemRepository shoppingItemRepository = ShoppingItemRepository();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add an Item"),
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

            shoppingItemRepository.addItem(
                widget.groupId,
                productName,
                productDescription,
                productQuantity,
                _selectedUnit!,
                ShoppingItemState.NotBought);
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
  }
}
