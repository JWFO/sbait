import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How To Shark Bait'),
      ),
      drawer: _buildDrawer(context),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SHARK BAIT RULES',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '1. Set up groups of 3, 4, or 5.\n\n'
              '2. The SHARK BAIT will compete against each opponent, for the alotted time, during their round.\n\n'
              '3. When the time is up, the next SHARK rotates in to face the SHARK BAIT.\n\n'
              '4. When the SHARK BAIT has faced each opponent, the next group member becomes the SHARK BAIT and the rotation starts with again.\n\n'
              '5. Once each group member has completed their turn as SHARK BAIT, the Round is over\n\n\n'
              'For example in a 4 person group:\n'
              'ROUND 1: 1 & 2 > 1 & 3 > 1 & 4\n'
              'ROUND 2: 2 & 3 > 2 & 4 > 2 & 1\n'
              'ROUND 3: 3 & 4 > 3 & 1 > 3 & 2\n'
              'ROUND 4: 4 & 1 > 4 & 2 > 4 & 3\n\n'

              'NOTES:\n'
              'If you have enable Positions, then the list will rotate after each group member has hosted the other opponents. You can use this to simulate a match.\n\n'
              'Enabling Alerts will give you a pop-up alert for the follow situations:\n'
              'When the time is up to switch SHARKS.\n'
              'When it is time to switch SHARK BAIT.\n'
              'When the round is over and the groups should switch to the next Position (if positions are enabled).\n\n',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
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
          /* REMOVING SETUP FROM DRAWER
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