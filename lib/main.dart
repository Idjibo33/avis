import 'package:avis/Helpers/snackbar.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Providers/profile_table_provider.dart';
import 'package:avis/auth_gate.dart';
import 'package:avis/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Les clés sont fournies au build, jamais commitées :
// flutter run --dart-define-from-file=.env
// flutter build web --dart-define=URL=... --dart-define=ANONKEY=...
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const String url = String.fromEnvironment('URL');
  const String anonKey = String.fromEnvironment('ANONKEY');
  await Supabase.initialize(url: url, anonKey: anonKey);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthServicesProviders()),
        ChangeNotifierProvider(create: (context) => ProfileTableProvider()),
        ChangeNotifierProvider(create: (context) => PostTableProider()),
        ChangeNotifierProvider(
          create: (context) => InteractionsServicesProvider(),
        ),
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
      scaffoldMessengerKey: messengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: backgroundCouleureBleue),
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
