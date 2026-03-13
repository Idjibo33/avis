import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Screens/authentication_screen.dart';
import 'package:avis/Screens/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthServicesProviders>(
      builder: (context, value, child) => StreamBuilder(
        stream: value.authServices.authState,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          if (snapshot.hasData) {
            final Session? session = snapshot.data!.session;
            if (session != null) {
              return const FeedScreen();
            } else {
              return const AuthenticationScreen();
            }
          }
          return const AuthenticationScreen();
        },
      ),
    );
  }
}
