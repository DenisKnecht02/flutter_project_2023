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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
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
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            widget.group.description ?? '',
            style: const TextStyle(fontSize: 14.0),
          ),
        ),
        // leading: Image(
        // ),
        trailing: PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case 'delete':
                // handle delete action
                break;
              case 'Update':
                // handle Update action
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
            const PopupMenuItem(
              value: 'Update',
              child: Text('Update'),
            ),
          ],
          icon: _meatballMenuIcon,
        ),
        onTap: () {},
      ),
    );
  }
}
