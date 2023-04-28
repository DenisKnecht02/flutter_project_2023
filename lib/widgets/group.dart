import 'package:flutter/material.dart';
import 'package:flutter_project_2023/repositories/group_model.dart';
import 'package:flutter_project_2023/shared/enums.dart';

class GroupWidget extends StatefulWidget {
  final Group group;

  GroupWidget({Key? key, required this.group}) : super(key: key);

  @override
  _GroupWidgetState createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final _meatballMenuIcon = const Icon(Icons.more_vert);

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
          onSelected: (value) {
            switch (value) {
              case 'delete':
                // handle delete action
                break;
              case 'edit':
                // handle Update action
                break;
              case 'copy_invite_code':
                break;
              case 'view_details':
                Scaffold.of(context).showBottomSheet<void>(
                    (BuildContext context) {
                  return Container(
                    height: 200,
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
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'copy_invite_code',
              child: Text('Copy Invite Code'),
            ),
            const PopupMenuItem(
              value: 'view_details',
              child: Text('View details'),
            ),
          ],
          icon: _meatballMenuIcon,
        ),
        onTap: () {
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
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (widget.group.description != null) ...[
                      Text(
                        widget.group.description!,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                    Text(
                      "Created by: ${widget.group.creatorId}",
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
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
                ),
              );
            },
            barrierDismissible: true,
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: Theme.of(context).colorScheme.background,
            transitionDuration: const Duration(milliseconds: 200),
          );
        },
      ),
    );
  }
}
