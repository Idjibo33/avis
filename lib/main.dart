import 'package:avis/Screens/authentication_screen.dart';
import 'package:avis/constants.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: backgroundCouleureBleue),
      ),
      debugShowCheckedModeBanner: false,
      home: AuthenticationScreen(),
    );
  }
}
