import 'package:flutter/material.dart';
import 'package:flutter_project_2023/repositories/group_repository.dart';
import 'package:flutter_project_2023/repositories/shopping_item_repository.dart';
import 'package:flutter_project_2023/widgets/group.dart';
import 'package:flutter_project_2023/widgets/shopping_item.dart';

class GrouPage extends StatelessWidget {
  GroupRepository groupRepository = GroupRepository();

  GrouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: FutureBuilder(
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
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Scaffold.of(context).showBottomSheet<void>((BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height,
                margin:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text("Create Group",
                          style: TextStyle(
                            fontSize: 24.0,
                          )),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: "Group Name",
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              child: const Text('Create group'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          const SizedBox(
                            width: 10.0,
                          ),
                          ElevatedButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }, backgroundColor: Colors.white);
          },
          child: const Icon(Icons.add)),
    );
  }
}
