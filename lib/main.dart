import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_sample_app/src/screens/register_password_view.dart';
import 'package:chat_sample_app/src/screens/validate_password_view.dart';

Future<bool> isFirstLaunch() async {
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (isFirstLaunch) {
    await prefs.setBool('isFirstLaunch', false);
  }
  return isFirstLaunch;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool firstLaunch = await isFirstLaunch();
  runApp(MyApp(firstLaunch: firstLaunch));
} 

class MyApp extends StatelessWidget {
  final bool firstLaunch;
  const MyApp({super.key, required this.firstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: firstLaunch ? const RegisterPasswordScreen() : ValidatePasswordScreen(),
    );
  }
}
