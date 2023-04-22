import 'package:flutter/material.dart';
import 'package:flutter_project_2023/repositories/shopping_item_repository.dart';
import 'package:flutter_project_2023/widgets/shopping_item.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
        ),
      ),
      body: FutureBuilder(
        future: shoppingListRepository.getShoppingList(),
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
