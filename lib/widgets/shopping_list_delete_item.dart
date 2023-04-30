import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_2023/shared/enums.dart';

class ShoppingListDeleteItem extends StatefulWidget {
  const ShoppingListDeleteItem({Key? key}) : super(key: key);

  @override
  _ShoppingListDeleteItemState createState() => _ShoppingListDeleteItemState();
}

class _ShoppingListDeleteItemState extends State<ShoppingListDeleteItem> {
  bool _allSelected = false;
  bool _boughtSelected = false;
  bool _notAvailableSelected = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Items to Delete"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            title: const Text("Bought"),
            value: _boughtSelected,
            onChanged: (bool? value) {
              setState(() {
                _boughtSelected = value ?? false;
                if (_boughtSelected && _notAvailableSelected) {
                  _allSelected = false;
                } else {
                  _allSelected = _boughtSelected && _notAvailableSelected;
                }
              });
            },
          ),
          CheckboxListTile(
            title: const Text("Not Available"),
            value: _notAvailableSelected,
            onChanged: (bool? value) {
              setState(() {
                _notAvailableSelected = value ?? false;
                if (_boughtSelected && _notAvailableSelected) {
                  _allSelected = false;
                } else {
                  _allSelected = _boughtSelected && _notAvailableSelected;
                }
              });
            },
          ),
          CheckboxListTile(
            title: const Text("All"),
            value: _allSelected,
            onChanged: (bool? value) {
              setState(() {
                _allSelected = value ?? false;
                _boughtSelected = value ?? false;
                _notAvailableSelected = value ?? false;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            // Do something with the selected items
            print(
                "All: $_allSelected, Bought: $_boughtSelected, Not Available: $_notAvailableSelected");
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
