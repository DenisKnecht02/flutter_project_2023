import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_2023/repositories/user_repository.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final UserRepository userRepository = UserRepository();
  final TextEditingController _controller = TextEditingController();

  String? username;

  @override
  void initState() {
    userRepository
        .getUserNameById(FirebaseAuth.instance.currentUser!.uid)
        .then((value) => setState(() {
              username = value;
              _controller.text = username ?? '';
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Name"),
              onChanged: (value) {
                username = value;
              },
            ),
            IconButton(
                onPressed: () {
                  if (username == null) return;
                  userRepository.changeDisplayName(
                      FirebaseAuth.instance.currentUser!.uid, username!);
                },
                icon: const Icon(Icons.done)),
            TextButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/sign-in');
                },
                icon: const Icon(Icons.logout),
                label: const Text("Sign Out")),
            TextButton.icon(
                onPressed: () {
                  // TODO: error handling
                  userRepository
                      .deleteUser(FirebaseAuth.instance.currentUser!.uid);
                  FirebaseAuth.instance.currentUser!.delete();
                  Navigator.pushReplacementNamed(context, '/sign-in');
                },
                icon: const Icon(Icons.delete),
                label: const Text("Delete Account"))
          ],
        ),
      ),
    );
  }
}
