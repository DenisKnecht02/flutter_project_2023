import 'package:flutter/material.dart';
import 'package:flutter_project_2023/repositories/group_model.dart';
import 'package:flutter_project_2023/repositories/group_repository.dart';
import 'package:flutter_project_2023/repositories/groups_model.dart';
import 'package:flutter_project_2023/repositories/shopping_item_repository.dart';
import 'package:flutter_project_2023/widgets/shopping_item.dart';
import 'package:flutter_project_2023/widgets/shopping_list_add_item.dart';

import '../../shared/enums.dart';
import '../shopping_list_delete_item.dart';

import '../../repositories/shopping_list_model.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  String? _selectedGroupId;
  ShoppingItemRepository shoppingListRepository = ShoppingItemRepository();
  GroupRepository groupRepository = GroupRepository();
  Groups userGroups = Groups([]);

  getGroupNames() async {
    userGroups = await groupRepository.getGroups();
    _selectedGroupId = userGroups.groups.first.id;
    setState(() {});
  }

  void initState() {
    getGroupNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: false,
          title: DropdownButton<String>(
            value: _selectedGroupId,
            onChanged: (String? newValue) {
              setState(() {
                _selectedGroupId = newValue;
              });
            },
            items:
                userGroups.groups.map<DropdownMenuItem<String>>((Group value) {
              return DropdownMenuItem<String>(
                value: value.id,
                child: Text(
                  value.name,
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
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(Icons.delete_outlined),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) =>
                            const ShoppingListDeleteItem(),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const ShoppingListAddItem(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: _selectedGroupId == null
          ? null
          : FutureBuilder(
              future: shoppingListRepository.getShoppingList(_selectedGroupId!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // sort the items by state: NotBought -> NotAvailable -> Bought
                  final sortedItems = snapshot.data!.items.toList()
                    ..sort((a, b) {
                      if (a.state == b.state) {
                        return 0;
                      } else if (a.state == ShoppingItemState.NotBought) {
                        return -1;
                      } else if (b.state == ShoppingItemState.NotBought) {
                        return 1;
                      } else if (a.state == ShoppingItemState.NotAvailable) {
                        return -1;
                      } else if (b.state == ShoppingItemState.NotAvailable) {
                        return 1;
                      } else {
                        return 1;
                      }
                    });

                  return SingleChildScrollView(
                    child: Column(
                      children: sortedItems
                          .map((item) => ShoppingItemWidget(shoppingItem: item))
                          .toList(),
                    ),
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {});
        },
        icon: const Icon(Icons.refresh),
        label: const Text('Refresh'),
      ),
    );
  }
}
