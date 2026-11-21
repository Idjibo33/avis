import 'dart:async';

import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Screens/feed_screen.dart';
import 'package:avis/State/auth_gate_state.dart';
import 'package:avis/constants.dart';
import 'package:avis/widgets/corps_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Le feed est la vue de départ. La session est lue depuis le dépôt injecté :
/// aucun ValueKey de retry, aucun plein écran de connexion au lancement.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthElevationController _elevation = AuthElevationController();

  @override
  void initState() {
    super.initState();
    // La session est lue par Consumer : on diffère l'initialisation pour ne
    // pas notifier les providers pendant la phase de build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(context.read<AuthServicesProviders>().initialize());
    });
  }

  @override
  void dispose() {
    _elevation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthElevationController>.value(
      value: _elevation,
      child: Consumer<AuthServicesProviders>(
        builder: (context, auth, child) {
          final AuthGateViewState vue = AuthGateViewState.from(auth.current);
          return switch (vue.status) {
            AuthGateStatus.loading => const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()),
            ),
            AuthGateStatus.guest ||
            AuthGateStatus.authenticated => const FeedScreen(),
            AuthGateStatus.failed => Scaffold(
              body: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(espaceLg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: espaceMd,
                      children: [
                        const CorpsTextWidget(
                          texte: 'Impossible de vérifier la session',
                        ),
                        if (vue.erreur != null)
                          CorpsTextWidget(texte: vue.erreur!),
                        FilledButton(
                          onPressed: () => unawaited(auth.initialize()),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          };
        },
      ),
    );
  }
}
