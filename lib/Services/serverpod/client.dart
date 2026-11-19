import 'package:avis_client/avis_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Construit le client généré et lui attache le gestionnaire de session Flutter.
Client createServerpodClient(Uri serverUri) {
  return Client(serverUri.toString())
    ..authSessionManager = FlutterAuthSessionManager();
}

Client? _sharedClient;

/// Client partagé par les adaptateurs de données lorsqu'aucun client n'est
/// injecté explicitement.
Client get serverpodClient =>
    _sharedClient ??= createServerpodClient(Uri.parse('http://localhost:8080'));

/// Enregistre le client créé au démarrage comme client partagé.
void registerSharedClient(Client client) => _sharedClient = client;
