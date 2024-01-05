import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/utils/functions.dart';
import 'package:frontend/widget/switcher.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() {
    return _DrawerWidgetState();
  }
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(email),
            accountName: Text(name),
            currentAccountPicture: const CircleAvatar(
              child: Icon(CupertinoIcons.profile_circled),
            ),
          ),
          const SizedBox(height: 15),
          ListTile(
            title: Row(
              children: [
                const Text('Theme Mode'),
                const Spacer(),
                const Icon(CupertinoIcons.sun_max),
                Switcher(),
                const Icon(CupertinoIcons.moon),
              ],
            ),
          ),
          ListTile(
            title: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text(
                'Log out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
