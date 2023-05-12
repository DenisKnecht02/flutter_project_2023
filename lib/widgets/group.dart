import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_2023/repositories/group_model.dart';
import 'package:flutter_project_2023/repositories/group_repository.dart';
import 'package:flutter_project_2023/shared/enums.dart';

class GroupWidget extends StatefulWidget {
  final Group group;

  GroupWidget({super.key, required this.group}) {}

  @override
  _GroupWidgetState createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final _meatballMenuIcon = const Icon(Icons.more_vert);

  GroupRepository groupRepository = GroupRepository();

  late String groupName;
  late String groupDescription;
  late List<String> userIds;

  @override
  void initState() {
    resetData();
  }

  void resetData() {
    setState(() {
      groupName = widget.group.name;
      groupDescription =
          widget.group.description == null ? '' : widget.group.description!;
      userIds = [...widget.group.userIds];
    });
  }

  void showEditScreen() {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: TextEditingController()..text = groupName,
                decoration: const InputDecoration(
                  hintText: 'Group Name',
                ),
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
                onChanged: (value) {
                  setState(() {
                    groupName = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: TextEditingController()..text = groupDescription,
                decoration: const InputDecoration(
                  hintText: 'Group Description',
                ),
                style: const TextStyle(
                  fontSize: 18.0,
                ),
                onChanged: (value) {
                  setState(() {
                    groupDescription = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Created by: ${widget.group.creatorId}",
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                key: Key(userIds.length.toString()),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Dismissible(
                      key: Key(userIds[index]),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          userIds.removeAt(index);
                        });
                      },
                      background: Container(
                        padding: const EdgeInsetsDirectional.only(end: 20),
                        alignment: Alignment.centerRight,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                        ),
                        child: const Icon(
                          Icons.group_remove,
                          color: Colors.white,
                        ),
                      ),
                      child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.zero)),
                          margin: const EdgeInsets.only(bottom: 8),
                          key: Key(userIds[index]),
                          child: ListTile(
                            title: Text(userIds[index]),
                            trailing: const Icon(Icons.arrow_back),
                          )),
                    ),
                  );
                },
                itemCount: userIds.length,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      groupRepository.updateGroupInfo(
                          widget.group.id, groupName, groupDescription);

                      List<String> removedUserIds =
                          widget.group.userIds.where((element) {
                        return !userIds.contains(element);
                      }).toList();

                      print(removedUserIds);

                      for (var removedUserId in removedUserIds) {
                        groupRepository.removeUser(
                            widget.group.id, removedUserId);
                      }

                      Navigator.pop(context);
                      // TODO: refresh page
                    },
                    icon: const Icon(
                      Icons.save,
                      size: 24.0,
                    ),
                    label: const Text('Save'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      resetData();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 24.0,
                    ),
                    label: const Text('Cancel'),
                  ),
                ],
              )
            ],
          ),
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Theme.of(context).colorScheme.background,
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  void showDetailsScreen() {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.group.name,
                softWrap: true,
                overflow: TextOverflow.clip,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              if (widget.group.description != null) ...[
                Text(
                  widget.group.description!,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
              Text(
                "Created by: ${widget.group.creatorId}",
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(widget.group.userIds[index]),
                    ),
                  );
                },
                itemCount: widget.group.userIds.length,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.group.creatorId ==
                      FirebaseAuth.instance.currentUser!.uid) ...[
                    ElevatedButton.icon(
                      onPressed: () {
                        showEditScreen();
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 24.0,
                      ),
                      label: const Text('Edit'),
                    ),
                    const SizedBox(width: 16),
                  ],
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 24.0,
                    ),
                    label: const Text('Close'),
                  ),
                ],
              )
            ],
          ),
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Theme.of(context).colorScheme.background,
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            blurRadius: 4.0,
            offset: const Offset(2.0, 2.0),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          widget.group.name,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: widget.group.description == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  widget.group.description ?? '',
                  style: const TextStyle(fontSize: 14.0),
                ),
              ),
        trailing: PopupMenuButton(
          onSelected: (value) async {
            switch (value) {
              case 'delete':
                groupRepository.deleteGroup(widget.group.id);
                // TODO: refresh page
                break;
              case 'copy_invite_code':
                await Clipboard.setData(ClipboardData(text: widget.group.id));
                break;
              case 'view_details':
                showEditScreen();
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
            const PopupMenuItem(
              value: 'copy_invite_code',
              child: Text('Copy Invite Code'),
            ),
          ],
          icon: _meatballMenuIcon,
        ),
        onTap: () {
          showDetailsScreen();
        },
      ),
    );
  }
}
