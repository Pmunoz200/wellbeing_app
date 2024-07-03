import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gemini_folder/firebase/firebase_options.dart';
import 'package:gemini_folder/pages/onboarding_page/onboarding.dart';
import 'package:gemini_folder/pages/profile_page/profile_widget.dart';
import 'package:gemini_folder/providers/main_provider.dart';
import 'package:gemini_folder/pages/user_authentication_page/login.dart';
import 'package:gemini_folder/util/app_theme.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => MainProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<NavigatorState> mainNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppThemeData.getThemeData(),
      initialRoute: '/authentication',
      navigatorKey: mainNavigatorKey,
      routes: {
        "/authentication": (context) => LoginScreen(
              navigator: mainNavigatorKey,
            ),
        '/home': (context) => const HomePage(),
        '/profile': (context) => ProfileWidgetPage(navigator: mainNavigatorKey),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/onboarding') {
          // This route is handled like this as an argument can be passed
          // on the navigation and it needs to be passe dto the Widget.
          final index = settings.arguments as int?;
          return MaterialPageRoute(
            builder: (context) {
              return OnboardingScreen(
                navigator: mainNavigatorKey,
                focusQuestionIndex: index,
              );
            },
          );
        }
        // Default case
        return null;
      },
    );
  }
}
