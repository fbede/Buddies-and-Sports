import 'package:buddies_and_sports/firebase_options.dart';
import 'package:buddies_and_sports/router/router.dart';
import 'package:buddies_and_sports/utils/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  GetIt.I.registerSingleton<SharedPreferences>(prefs);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: UserText.APPNAME,
      routerConfig: router,
    );
  }
}
