import 'package:avis/Helpers/snackbar.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Providers/profile_table_provider.dart';
import 'package:avis/Services/auth_repository.dart';
import 'package:avis/Services/serverpod/auth_repository_factory.dart';
import 'package:avis/Services/serverpod/client.dart';
import 'package:avis/Services/serverpod/interactions_services.dart';
import 'package:avis/Services/serverpod/posts_table_services.dart';
import 'package:avis/Services/serverpod/profile_table_services.dart';
import 'package:avis/Services/serverpod/storage_services.dart';
import 'package:avis/auth_gate.dart';
import 'package:avis/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// L'adresse du backend est fournie au build, jamais codée en dur :
// flutter run --dart-define=SERVERPOD_URL=http://localhost:8080
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String serverpodUrl = String.fromEnvironment(
    'SERVERPOD_URL',
    defaultValue: 'http://localhost:8080',
  );
  final AuthRepository authRepository = createAuthRepository(
    serverUri: Uri.parse(serverpodUrl),
  );
  final client = serverpodClient;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              AuthServicesProviders(repository: authRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileTableProvider(
            profileTableServices: ProfileTableServices(client: client),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => PostTableProider(
            postsTableServices: PostsTableServices(client: client),
            storageServices: StorageServices(client: client),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => InteractionsServicesProvider(
            interactions: InteractionsServices(client: client),
          ),
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
      theme: appTheme(),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
