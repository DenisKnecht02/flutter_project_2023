import 'package:flutter/material.dart';
import 'package:flutter_project_2023/repositories/group_repository.dart';
import 'package:flutter_project_2023/repositories/shopping_item_repository.dart';
import 'package:flutter_project_2023/widgets/group.dart';
import 'package:flutter_project_2023/widgets/shopping_item.dart';

class GrouPage extends StatelessWidget {
  GroupRepository groupRepository = new GroupRepository();
  GrouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: FutureBuilder(
        future: groupRepository.getGroups(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: snapshot.data?.groups
                        .map((item) => GroupWidget(group: item))
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
    );
  }
}
