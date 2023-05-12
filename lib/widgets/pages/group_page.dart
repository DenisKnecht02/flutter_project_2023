import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_2023/repositories/group_repository.dart';
import 'package:flutter_project_2023/repositories/shopping_item_repository.dart';
import 'package:flutter_project_2023/widgets/group.dart';
import 'package:flutter_project_2023/widgets/shopping_item.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  GroupRepository groupRepository = GroupRepository();

  String groupName = "";
  String groupDescription = "";
  String inviteCode = "";

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
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloatingActionButton(
                onPressed: () {
                  Scaffold.of(context).showBottomSheet<void>(
                      (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 4.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text("Create Group",
                                style: TextStyle(
                                  fontSize: 24.0,
                                )),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "Group Name",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  groupName = value;
                                });
                              },
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "Group Description",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  groupDescription = value;
                                });
                              },
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
                                      groupRepository.createGroup(
                                          groupName, groupDescription);
                                      Navigator.pop(context);
                                      setState(() {});
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
            const SizedBox(width: 20),
            FloatingActionButton(
                onPressed: () {
                  Scaffold.of(context).showBottomSheet<void>(
                      (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 4.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text("Join Group",
                                style: TextStyle(
                                  fontSize: 24.0,
                                )),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: "Invite Code",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  inviteCode = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    child: const Text('Join group'),
                                    onPressed: () {
                                      groupRepository.addUser(
                                          inviteCode,
                                          FirebaseAuth
                                              .instance.currentUser!.uid);
                                      Navigator.pop(context);
                                      setState(() {});
                                      // TODO: refresh page
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
                child: const Icon(Icons.group_add)),
          ],
        ));
  }
}
