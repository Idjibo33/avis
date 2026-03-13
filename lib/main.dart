import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/profile_table_provider.dart';
import 'package:avis/auth_gate.dart';
import 'package:avis/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['URL'] ?? '',
    anonKey: dotenv.env['ANONKEY'] ?? '',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthServicesProviders()),
        ChangeNotifierProvider(create: (context) => ProfileTableProvider()),
      ],
      child: const MainApp(),
    ),
  );
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
      home: AuthGate(),
    );
  }
}
