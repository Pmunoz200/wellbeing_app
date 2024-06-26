import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gemini_folder/firebase/firebase_options.dart';
import 'package:gemini_folder/onboarding/onboarding.dart';
import 'package:gemini_folder/token_page.dart';
import 'package:gemini_folder/user_authentication/login.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<NavigatorState> mainNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFF0E86D4).withOpacity(0.8),
        cardColor: const Color(0xFFE3E7EE),
        textTheme: TextTheme(
          bodyMedium: const TextStyle(fontFamily: 'Montserrat', fontSize: 14.0),
          bodyLarge: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.grey[700], fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: '/authentication',
      navigatorKey: mainNavigatorKey,
      routes: {
        "/authentication": (context) => LoginScreen(
              navigator: mainNavigatorKey,
            ),
        '/token': (context) => HomePage(),
        '/onboarding': (context) =>
            OnboardingScreen(navigator: mainNavigatorKey),
        'home': (context) => HomePage(),
      },
    );
  }
}
