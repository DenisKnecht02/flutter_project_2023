import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_2023/repositories/user_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserRepository userRepository = UserRepository();
  final TextEditingController _controller = TextEditingController();

  User? user;
  String username = "";
  String password = "";
  Widget? suffixIcon;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    setState(() {
      username = user!.displayName ?? 'Anonymous';
      _controller.text = username;
    });
  }

  completeDeletingUser() {
    userRepository.deleteUser(user!.uid);
    Navigator.pushReplacementNamed(context, '/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  suffixIcon: suffixIcon),
              onChanged: (value) {
                setState(() {
                  username = value;
                  suffixIcon = const Icon(Icons.close, color: Colors.red);
                });
              },
            ),
            const SizedBox(height: 32.0),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  suffixIcon = const Icon(Icons.check, color: Colors.green);
                });
                if (username == null) return;
                userRepository.changeDisplayName(
                  user!.uid,
                  username,
                );
              },
              icon: Icon(Icons.save),
              label: Text('Save'),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text(
                        'Are you sure you want to delete your account?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.currentUser!
                              .delete()
                              .then((_) => completeDeletingUser())
                              .onError((error, stackTrace) => {
                                    Navigator.pop(context),
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Confirm'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            const Text(
                                                'Please enter your password to delete your account:'),
                                            const SizedBox(height: 20),
                                            TextField(
                                              obscureText: true,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              decoration: InputDecoration(
                                                labelText: 'Your password',
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue),
                                                ),
                                                labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              onChanged: (value) {
                                                password = value;
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              FirebaseAuth.instance
                                                  .signInWithEmailAndPassword(
                                                      email: user!.email!,
                                                      password: password);
                                              FirebaseAuth.instance.currentUser!
                                                  .delete()
                                                  .then((_) =>
                                                      completeDeletingUser())
                                                  .onError(
                                                      (error, stackTrace) => {
                                                            Navigator.pop(
                                                                context),
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AlertDialog(
                                                                        title: const Text(
                                                                            "Failed"),
                                                                        content:
                                                                            const Text(
                                                                                'Sorry, deleting your account was not successful. Please try again and check if your password was correct.'),
                                                                        actions: <
                                                                            Widget>[
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(context),
                                                                            child:
                                                                                const Text('Ok'),
                                                                          ),
                                                                        ]))
                                                          });
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    )
                                  });
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.delete),
              label: Text('Delete Account'),
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
