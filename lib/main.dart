import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gemini_folder/firebase/firebase_options.dart';
import 'package:gemini_folder/onboarding/onboarding.dart';
import 'package:gemini_folder/token_page.dart';
import 'package:gemini_folder/user_authentication/login.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/authentication',
      navigatorKey: mainNavigatorKey,
      routes: {
        "/authentication": (context) => LoginScreen(
              navigator: mainNavigatorKey,
            ),
        '/token': (context) => TokenPage(navigator: mainNavigatorKey),
        '/onboarding': (context) =>
            OnboardingScreen(navigator: mainNavigatorKey)
      },
    );
  }
}
