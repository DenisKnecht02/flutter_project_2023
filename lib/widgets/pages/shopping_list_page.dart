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
  String? _selectedGroup = 'Select Group';
  ShoppingItemRepository shoppingListRepository = new ShoppingItemRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: DropdownButton<String>(
            value: _selectedGroup,
            onChanged: (String? newValue) {
              setState(() {
                _selectedGroup = newValue;
              });
            },
            items: <String>['Select Group', 'Group1', 'Group2', 'Group3']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            underline: Container(),
          ),
        ),
      ),
      body: FutureBuilder(
        future: shoppingListRepository.getShoppingList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: snapshot.data?.items
                        .map((item) => ShoppingItemWidget(shoppingItem: item))
                        .toList() ??
                    [],
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        },
      ),
    );
  }
}
