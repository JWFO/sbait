import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/setup_screen.dart';
import 'screens/rules_screen.dart';
import 'screens/contact_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const TimerApp());
}

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shark Bait',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: const SetupScreen(),
            initialRoute: '/',
            routes: {
              '/': (context) => const SetupScreen(),
              '/rules': (context) => const RulesScreen(),
              '/contact': (context) => const ContactScreen(),
            },
    );
  }
}
