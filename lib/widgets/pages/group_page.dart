import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_2023/repositories/group_repository.dart';
import 'package:flutter_project_2023/repositories/groups_model.dart';
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
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: groupRepository.getGroupsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Groups groups =
                      Groups.fromFirestoreStream(snapshot.data!.docs);

                  return groups.groups.isEmpty
                      ? const Center(
                          child: Text(
                              "You are currently not a member of a group! You can create a new or join an existing group.",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.center),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: groups.groups
                                .map((item) => GroupWidget(group: item))
                                .toList(),
                          ),
                        );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
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
                                      groupName = "";
                                      groupDescription = "";
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
                                    onPressed: () async {
                                      try {
                                        await groupRepository.addUser(
                                            inviteCode,
                                            FirebaseAuth
                                                .instance.currentUser!.uid);
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                        setState(() {});
                                      } catch (e) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Error'),
                                            content: const Text(
                                                'The invite code is invalid!'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop(); // dismisses only the dialog and returns nothing
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                        inviteCode = "";
                                        setState(() {});
                                      }
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
