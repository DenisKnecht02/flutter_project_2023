import 'package:flutter/material.dart';
import 'package:flutter_project_2023/repositories/shopping_item_repository.dart';
import 'package:flutter_project_2023/widgets/shopping_item.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../repositories/shopping_list_model.dart';

class ShoppingListPage extends StatefulWidget {
  ShoppingListPage({Key? key}) : super(key: key);

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  String? _selectedGroup;
  ShoppingItemRepository shoppingListRepository = new ShoppingItemRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: false,
          title: DropdownButton<String>(
            value: _selectedGroup,
            onChanged: (String? newValue) {
              setState(() {
                _selectedGroup = newValue;
              });
            },
            items: <String>['Group1', 'Group2', 'Group3']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
            style: const TextStyle(color: Colors.black),
            hint: const Text(
              'Select a Group',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            underline: Container(
              height: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
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
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.delete_outlined),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      bool _allSelected = false;
                      bool _boughtSelected = false;
                      bool _notAvailableSelected = false;

                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            title: Text("Select Items to Delete"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CheckboxListTile(
                                  title: Text("Bought"),
                                  value: _boughtSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _boughtSelected = value ?? false;
                                      if (_boughtSelected &&
                                          _notAvailableSelected) {
                                        _allSelected = false;
                                      } else {
                                        _allSelected = _boughtSelected &&
                                            _notAvailableSelected;
                                      }
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: Text("Not Available"),
                                  value: _notAvailableSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _notAvailableSelected = value ?? false;
                                      if (_boughtSelected &&
                                          _notAvailableSelected) {
                                        _allSelected = false;
                                      } else {
                                        _allSelected = _boughtSelected &&
                                            _notAvailableSelected;
                                      }
                                    });
                                  },
                                ),
                                CheckboxListTile(
                                  title: Text("All"),
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
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  // Do something with the selected items
                                  print(
                                      "All: $_allSelected, Bought: $_boughtSelected, Not Available: $_notAvailableSelected");
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // TODO: Implement add item functionality here
                },
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: shoppingListRepository.getShoppingList("iDKiBckvDAkp4P5mF52q") , //ToDo: implement GroupId
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
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
