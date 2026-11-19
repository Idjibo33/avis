import 'package:serverpod_auth_idp_server/providers/anonymous.dart';

/// Expose la connexion anonyme native de Serverpod (`client.anonymousIdp.login()`).
///
/// L'UUID anonyme obtenu ici est conservé lors de l'élévation en compte
/// pseudo + mot de passe (voir [UsernameAuthEndpoint.register]).
class AnonymousIdpEndpoint extends AnonymousIdpBaseEndpoint {}
