import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_2023/repositories/shopping_item_repository.dart';
import 'package:flutter_project_2023/shared/enums.dart';

class ShoppingListDeleteItem extends StatefulWidget {
  final String groupId;

  const ShoppingListDeleteItem({Key? key, required this.groupId})
      : super(key: key);

  @override
  _ShoppingListDeleteItemState createState() => _ShoppingListDeleteItemState();
}

class _ShoppingListDeleteItemState extends State<ShoppingListDeleteItem> {
  ShoppingItemRepository shoppingItemRepository = ShoppingItemRepository();

  Map<DeleteItemsFilter, bool> selected = Map();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Items to Delete"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: DeleteItemsFilter.values.map((filter) {
          return CheckboxListTile(
            title: Text(filter.toString().split(".")[1]),
            value: selected[filter] ?? false,
            onChanged: (bool? value) {
              setState(() {
                selected[filter] = !(selected[filter] ?? false);

                if (filter == DeleteItemsFilter.All) {
                  for (var f in DeleteItemsFilter.values) {
                    selected[f] = selected[filter] ?? false;
                  }
                } else {
                  var allSelected = true;
                  for (var f in DeleteItemsFilter.values) {
                    if (f != DeleteItemsFilter.All &&
                        (selected[f] ?? false) == false) {
                      allSelected = false;
                      break;
                    }
                  }

                  selected[DeleteItemsFilter.All] = allSelected;
                }
              });
            },
          );
        }).toList(),
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
            List<DeleteItemsFilter> selectedFilters = [];

            for (var selectedFilter in selected.entries) {
              if (selectedFilter.key != DeleteItemsFilter.All &&
                  selectedFilter.value == true) {
                selectedFilters.add(selectedFilter.key);
              }
            }

            shoppingItemRepository.deleteItems(widget.groupId, selectedFilters);

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
