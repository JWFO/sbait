import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Timer'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          /* No Setup Page
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Setup'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/setup');
            },
          ),
          */
          ListTile(
            leading: const Icon(Icons.rule),
            title: const Text('Rules'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/rules');
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/contact');
            },
          ),
        ],
      ),
    );
  }
}