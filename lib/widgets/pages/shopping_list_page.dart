import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_2023/repositories/group_model.dart';
import 'package:flutter_project_2023/repositories/group_repository.dart';
import 'package:flutter_project_2023/repositories/groups_model.dart';
import 'package:flutter_project_2023/repositories/shopping_item_repository.dart';
import 'package:flutter_project_2023/widgets/shopping_item.dart';
import 'package:flutter_project_2023/widgets/shopping_list_add_item.dart';

import '../shopping_list_delete_item.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  ShoppingItemRepository shoppingListRepository = ShoppingItemRepository();

  String? _selectedGroupId;
  GroupRepository groupRepository = GroupRepository();
  Groups userGroups = Groups([]);

  getGroupNames() async {
    userGroups = await groupRepository.getGroups();
    if (userGroups.groups.isNotEmpty) {
      _selectedGroupId = userGroups.groups.first.id;
    }
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
            title: userGroups.groups.isEmpty
                ? null
                : DropdownButton<String>(
                    value: _selectedGroupId,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGroupId = newValue;
                      });
                    },
                    items: userGroups.groups
                        .map<DropdownMenuItem<String>>((Group value) {
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
          ),
        ),
        body: _selectedGroupId == null
            ? const Center(
                child: Text(
                    "You are currently not a member of a group! You can create a new or join an existing group in the group tab.",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center),
              )
            : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: shoppingListRepository
                    .getShoppingListStream(_selectedGroupId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    final group = Group.fromFirestore(snapshot.data!);
                    var items = [...group.shoppingList.items];
                    items.sort((a, b) {
                      return a.createdDate.compareTo(b.createdDate);
                    });

                    return group.shoppingList.items.isEmpty
                        ? const Center(
                            child: Text(
                                "There are currently no items in this list! You can add a new one with the button below.",
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: items
                                  .map((item) => ShoppingItemWidget(
                                      groupId: _selectedGroupId!,
                                      shoppingItem: item))
                                  .toList(),
                            ),
                          );
                  } else {
                    return const Center(
                      child: Text(
                          "You are currently not a member of a group! You can create a new or join an existing group in the group tab.",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center),
                    );
                  }
                },
              ),
        backgroundColor: Colors.white,
        floatingActionButton: _selectedGroupId == null
            ? null
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FloatingActionButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) =>
                              ShoppingListAddItem(groupId: _selectedGroupId!),
                        );
                      },
                      child: const Icon(Icons.add)),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (BuildContext context,
                                      StateSetter setState) =>
                                  ShoppingListDeleteItem(
                                      groupId: _selectedGroupId!),
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.delete_outline)),
                ],
              ));
  }
}
