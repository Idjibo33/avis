import 'package:avis/Services/auth_repository.dart';
import 'package:avis/Services/serverpod/client.dart';
import 'package:avis/Services/serverpod/serverpod_auth_repository.dart';

/// Point d'entrée unique : construit le client Serverpod, l'enregistre comme
/// client partagé des adaptateurs et renvoie le dépôt d'authentification.
AuthRepository createAuthRepository({required Uri serverUri}) {
  final client = createServerpodClient(serverUri);
  registerSharedClient(client);
  return ServerpodAuthRepository(client: client);
}
