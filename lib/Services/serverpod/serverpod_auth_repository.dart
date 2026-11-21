import 'dart:async';

import 'package:avis/Services/auth_repository.dart';
import 'package:avis_client/avis_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Adaptateur du dépôt d'authentification historique sur le client Serverpod.
///
/// L'identité vient toujours de la session du client : aucun identifiant n'est
/// fabriqué localement et aucun état `guest` n'est publié sans UUID.
class ServerpodAuthRepository implements AuthRepository {
  ServerpodAuthRepository({required this.client}) {
    client.auth.authInfoListenable.addListener(_onAuthInfoChanged);
  }

  final Client client;

  final StreamController<AuthSessionState> _controller =
      StreamController<AuthSessionState>.broadcast();

  AuthSessionState _current = const AuthSessionState(
    status: AuthSessionStatus.unknown,
  );

  /// Les changements provoqués par nos propres opérations sont publiés
  /// explicitement ; le listener ne doit pas les rejouer ni publier un état
  /// partiel (session en cours de création).
  int _operationsEnCours = 0;

  @override
  Stream<AuthSessionState> get state => _controller.stream;

  @override
  AuthSessionState get current => _current;

  Future<T> _dansOperation<T>(Future<T> Function() action) async {
    _operationsEnCours++;
    try {
      return await action();
    } finally {
      _operationsEnCours--;
    }
  }

  void _publier(AuthSessionState session) {
    _current = session;
    if (!_controller.isClosed) _controller.add(session);
  }

  void _onAuthInfoChanged() {
    if (_operationsEnCours > 0) return;
    final AuthSuccess? info = client.auth.authInfo;
    if (info == null) {
      // Une session fermée ailleurs ne doit pas laisser le feed sans identité.
      unawaited(_dansOperation(_signInAsGuest));
      return;
    }
    unawaited(
      _dansOperation(() => _publierAuthentifie(info.authUserId.toString())),
    );
  }

  Future<String?> _lirePseudo(String authUserId) async {
    try {
      return await client.publicFeed.authorName(
        UuidValue.fromString(authUserId),
      );
    } catch (_) {
      // Le pseudo est facultatif : un échec réseau ne bloque pas la session.
      return null;
    }
  }

  Future<void> _publierAuthentifie(String authUserId) async {
    final String? pseudo = await _lirePseudo(authUserId);
    // Une session remplacée pendant la lecture ne doit pas publier un état
    // périmé.
    if (client.auth.authInfo?.authUserId.toString() != authUserId) return;
    _publier(
      AuthSessionState(
        status: AuthSessionStatus.authenticated,
        authUserId: authUserId,
        pseudo: pseudo,
      ),
    );
  }

  Future<void> _signInAsGuest() async {
    final AuthSuccess succes = await client.anonymousIdp.login();
    await client.auth.updateSignedInUser(succes);
    _publier(
      AuthSessionState(
        status: AuthSessionStatus.guest,
        authUserId: succes.authUserId.toString(),
      ),
    );
  }

  @override
  Future<void> initialize() => _dansOperation(() async {
    try {
      await client.auth.initialize();
      if (client.auth.isAuthenticated) {
        await _publierAuthentifie(client.auth.authInfo!.authUserId.toString());
        return;
      }
      await _signInAsGuest();
    } catch (error) {
      // initialize() ne doit jamais laisser l'application dans un état
      // `unknown` : l'écran d'erreur offre un retry explicite.
      if (_current.status == AuthSessionStatus.unknown) {
        _publier(
          AuthSessionState(status: AuthSessionStatus.failed, error: error),
        );
      }
      rethrow;
    }
  });

  @override
  Future<void> signInAsGuest() => _dansOperation(_signInAsGuest);

  @override
  Future<void> elevate({required String pseudo, required String password}) =>
      _dansOperation(() async {
        final AuthSuccess succes = await client.usernameAuth.register(
          pseudo,
          password,
        );
        await client.auth.updateSignedInUser(succes);
        await _publierAuthentifie(succes.authUserId.toString());
      });

  @override
  Future<void> signIn({required String pseudo, required String password}) =>
      _dansOperation(() async {
        final AuthSuccess succes = await client.usernameAuth.signIn(
          pseudo,
          password,
        );
        await client.auth.updateSignedInUser(succes);
        await _publierAuthentifie(succes.authUserId.toString());
      });

  @override
  Future<void> signOut() => _dansOperation(() async {
    await client.auth.signOutDevice();
    // Le feed reste visible après déconnexion : on crée une nouvelle session
    // anonyme plutôt que de rester sans identité.
    await _signInAsGuest();
  });
}
