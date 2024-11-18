import 'package:flutter/material.dart';
import '../models/timer_settings.dart';
import 'countdown_screen.dart';
import '../widgets/app_drawer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int groupSize = 3;
  int minutes = 1;
  int seconds = 30;
  bool positionsEnabled = false;
  bool neutralEnabled = false;
  bool topEnabled = false;
  bool bottomEnabled = false;
  bool alarmEnabled = true;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup')),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Group Size', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [3, 4, 5].map((size) => 
                        ElevatedButton(
                          onPressed: () => setState(() => groupSize = size),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: groupSize == size ? Colors.blue : Colors.grey,
                          ),
                          child: Text('$size'),
                        ),
                      ).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Timer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text('Minutes'),
                            DropdownButton<int>(
                              value: minutes,
                              items: List.generate(11, (i) => i).map((i) =>
                                DropdownMenuItem(value: i, child: Text('$i')),
                              ).toList(),
                              onChanged: (value) => setState(() => minutes = value!),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Seconds'),
                            DropdownButton<int>(
                              value: seconds,
                              items: [0, 1, 15, 30, 45].map((i) =>
                                DropdownMenuItem(value: i, child: Text('$i')),
                              ).toList(),
                              onChanged: (value) => setState(() => seconds = value!),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Positions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Switch(
                          value: positionsEnabled,
                          onChanged: (value) => setState(() {
                            positionsEnabled = value;
                            if (!value) {
                              neutralEnabled = false;
                              topEnabled = false;
                              bottomEnabled = false;
                            }
                          }),
                        ),
                      ],
                    ),
                    if (positionsEnabled) ...[
                      CheckboxListTile(
                        title: const Text('Neutral'),
                        value: neutralEnabled,
                        onChanged: (value) => setState(() => neutralEnabled = value!),
                      ),
                      
                      CheckboxListTile(
                        title: const Text('Top'),
                        value: topEnabled,
                        onChanged: (value) => setState(() => topEnabled = value!),
                      ),

                      CheckboxListTile(
                        title: const Text('Bottom'),
                        value: bottomEnabled,
                        onChanged: (value) => setState(() => bottomEnabled = value!),
                      ),

                    ],
                    CheckboxListTile(
                      title: const Text('Alerts'),
                      value: alarmEnabled,
                      onChanged: (value) => setState(() => alarmEnabled = value!),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final settings = TimerSettings(
                  groupSize: groupSize,
                  minutes: minutes,
                  seconds: seconds,
                  positionsEnabled: positionsEnabled,
                  neutralEnabled: neutralEnabled,
                  topEnabled: topEnabled,
                  bottomEnabled: bottomEnabled,
                  alarmEnabled: alarmEnabled,
                );
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CountdownScreen(settings: settings),
                ));
              },
              child: const Text('SAVE'),
            ),
          ],
        ),
      ),
    );
  }
}