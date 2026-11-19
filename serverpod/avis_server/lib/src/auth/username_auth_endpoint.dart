import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// Authentification applicative « pseudo + mot de passe », sans email,
/// sans vérification et sans récupération.
///
/// Ce n'est volontairement pas un `IdentityProvider` : l'UUID créé par
/// `AnonymousIdpEndpoint.login` est conservé, on se contente d'émettre un
/// nouveau token avec la méthode `username`.
class UsernameAuthEndpoint extends Endpoint {
  static final RegExp _usernamePattern = RegExp(r'^[A-Za-z0-9_]{3,20}$');

  /// Enregistre un pseudo et un mot de passe pour l'utilisateur anonyme
  /// actuellement connecté. L'UUID du compte reste strictement le même.
  Future<AuthSuccess> register(
    Session session,
    String pseudo,
    String password,
  ) async {
    final username = pseudo.trim();
    if (!_usernamePattern.hasMatch(username)) {
      throw const FormatException('Pseudo invalide.');
    }
    if (password.length < 8) {
      throw const FormatException('Mot de passe trop court.');
    }

    final authUserId = session.authenticated?.authUserId;
    if (authUserId == null) {
      throw const FormatException('Session anonyme requise.');
    }

    final normalized = username.toLowerCase();
    final hasher = _passwordHasher(session);

    final existing = await UsernameAccount.db.findFirstRow(
      session,
      where: (t) => t.usernameNormalized.equals(normalized),
    );
    if (existing != null) {
      // Message volontairement générique : ne révèle pas l'existence du pseudo.
      throw const FormatException('Impossible de créer le compte.');
    }

    final passwordHash = await hasher.createHashFromString(secret: password);

    try {
      await UsernameAccount.db.insertRow(
        session,
        UsernameAccount(
          authUserId: authUserId,
          username: username,
          usernameNormalized: normalized,
          passwordHash: passwordHash,
        ),
      );
    } on DatabaseUniqueViolationException {
      // L'index unique protège aussi contre une course entre deux requêtes.
      throw const FormatException('Impossible de créer le compte.');
    }

    await AuthServices.instance.userProfiles.changeUserName(
      session,
      authUserId,
      username,
    );

    // Les jetons anonymes ne doivent pas survivre à l'élévation.
    await AuthServices.instance.tokenManager.revokeAllTokens(
      session,
      authUserId: authUserId,
      method: 'anonymous',
    );

    return AuthServices.instance.tokenManager.issueToken(
      session,
      authUserId: authUserId,
      method: 'username',
    );
  }

  /// Connecte un compte existant. Aucune session préalable n'est requise.
  @unauthenticatedClientCall
  Future<AuthSuccess> signIn(
    Session session,
    String pseudo,
    String password,
  ) async {
    final normalized = pseudo.trim().toLowerCase();
    final account = await UsernameAccount.db.findFirstRow(
      session,
      where: (t) => t.usernameNormalized.equals(normalized),
    );

    final passwordMatches =
        account != null &&
        await _passwordHasher(session).validateHashFromString(
          secret: password,
          hashString: account.passwordHash,
        );

    if (!passwordMatches) {
      // Même message pour pseudo inconnu et mauvais mot de passe.
      throw const FormatException('Pseudo ou mot de passe incorrect.');
    }

    return AuthServices.instance.tokenManager.issueToken(
      session,
      authUserId: account.authUserId,
      method: 'username',
    );
  }

  Argon2HashUtil _passwordHasher(Session session) {
    final pepper = session.passwords['usernamePasswordHashPepper'];
    if (pepper == null || pepper.isEmpty) {
      throw StateError(
        'Missing usernamePasswordHashPepper in config/passwords.yaml',
      );
    }
    return Argon2HashUtil(hashPepper: pepper, hashSaltLength: 16);
  }
}
