import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Screens/authentication_screen.dart';
import 'package:avis/Screens/feed_screen.dart';
import 'package:avis/State/auth_gate_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  int _tentative = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthServicesProviders>(
      builder: (context, value, child) => StreamBuilder<AuthState>(
        key: ValueKey(_tentative),
        stream: value.authServices.authState,
        builder: (context, snapshot) {
          final AuthGateViewState vue = AuthGateViewState.from(snapshot);
          return switch (vue.status) {
            AuthGateStatus.loading => const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            ),
            AuthGateStatus.signedIn => const FeedScreen(),
            AuthGateStatus.signedOut => const AuthenticationScreen(),
            AuthGateStatus.failed => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 12,
                  children: [
                    const Text('Impossible de vérifier la session'),
                    ElevatedButton(
                      onPressed: () => setState(() => _tentative++),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            ),
          };
        },
      ),
    );
  }
}
