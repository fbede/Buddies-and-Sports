import 'package:buddies_and_sports/router/route_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Privacy')),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: const [
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Update Username'),
                trailing: Icon(Icons.navigate_next),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('Change Email'),
                trailing: Icon(Icons.navigate_next),
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Change Password'),
                trailing: Icon(Icons.navigate_next),
              ),
            ],
          )),
          TextButton(
            onPressed: () => logout(context),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void logout(BuildContext context) async {
    final router = GoRouter.of(context);
    final prefs = GetIt.I<SharedPreferences>();
    try {
      await FirebaseAuth.instance.signOut();
      await prefs.clear();
      router.pushNamed(Routes.signIn);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
