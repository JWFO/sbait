import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/rules_screen.dart';
import 'screens/contact_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const SharkBaitApp());
}

class SharkBaitApp extends StatelessWidget {
  const SharkBaitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shark Bait',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: SplashScreen(),
            initialRoute: '/',
            routes: {
              '/': (context) => SplashScreen(),
              '/Timer Setup': (context) => const SetupScreen(),
              '/rules': (context) => const RulesScreen(),
              '/contact': (context) => const ContactScreen(),
            },
            
    );
  }
}
