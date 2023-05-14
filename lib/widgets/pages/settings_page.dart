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
    super.initState();
    userRepository
        .getUserNameById(FirebaseAuth.instance.currentUser!.uid)
        .then((value) {
      setState(() {
        username = value;
        _controller.text = username ?? 'Anonymous';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Update Your Name',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24.0),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
            ),
            const SizedBox(height: 32.0),
            ElevatedButton.icon(
              onPressed: () {
                if (username == null) return;
                userRepository.changeDisplayName(
                  FirebaseAuth.instance.currentUser!.uid,
                  username!,
                );
              },
              icon: Icon(Icons.save),
              label: Text('Save Changes'),
            ),
            const SizedBox(height: 24.0),
            TextButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/sign-in');
              },
              icon: Icon(Icons.logout),
              label: Text('Sign Out'),
            ),
            const SizedBox(height: 8.0),
            TextButton.icon(
              onPressed: () {
                // TODO: error handling
                userRepository
                    .deleteUser(FirebaseAuth.instance.currentUser!.uid);
                FirebaseAuth.instance.currentUser!.delete();
                Navigator.pushReplacementNamed(context, '/sign-in');
              },
              icon: Icon(Icons.delete),
              label: Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}
