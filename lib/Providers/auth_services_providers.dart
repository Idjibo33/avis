import 'dart:async';

import 'package:avis/Helpers/validation.dart';
import 'package:avis/Services/auth_repository.dart';
import 'package:avis/State/operation_state.dart';
import 'package:flutter/foundation.dart';

/// Unique façade cliente de l'authentification : le [AuthRepository] injecté
/// possède la session, ce provider n'expose que des opérations et leurs états.
class AuthServicesProviders extends ChangeNotifier {
  AuthServicesProviders({required AuthRepository repository})
    : _repository = repository {
    _abonnement = repository.state.listen(
      _surSession,
      onError: (Object error, StackTrace stack) {
        _surSession(
          AuthSessionState(status: AuthSessionStatus.failed, error: error),
        );
      },
    );
  }

  final AuthRepository _repository;
  late final StreamSubscription<AuthSessionState> _abonnement;
  final StreamController<AuthSessionState> _sessions =
      StreamController<AuthSessionState>.broadcast();

  AuthSessionState _session = const AuthSessionState(
    status: AuthSessionStatus.unknown,
  );
  OperationState _operation = const OperationIdle();

  AuthRepository get repository => _repository;

  /// Flux de session redistribué : un seul abonnement au dépôt, plusieurs
  /// consommateurs côté widgets sans exiger un flux broadcast du dépôt.
  Stream<AuthSessionState> get state => _sessions.stream;

  AuthSessionState get current => _session;
  OperationState get operation => _operation;
  bool get chargement => _operation.isRunning;
  String get messageErreur => _operation.errorMessage ?? '';

  void _surSession(AuthSessionState session) {
    _session = session;
    if (!_sessions.isClosed) _sessions.add(session);
    notifyListeners();
  }

  void _setOperation(OperationState nouvelEtat) {
    _operation = nouvelEtat;
    notifyListeners();
  }

  /// Une seule opération à la fois ; tout échec reste explicite et le message
  /// est effacé au succès suivant. Aucun snackbar : la feuille affiche l'erreur.
  Future<bool> _executer(Future<void> Function() action) async {
    if (_operation.isRunning) return false;
    _setOperation(const OperationRunning());
    try {
      await action();
      _setOperation(const OperationSucceeded(''));
      return true;
    } catch (e) {
      _setOperation(OperationFailed(e.toString()));
      return false;
    }
  }

  Future<bool> initialize() => _executer(_repository.initialize);

  Future<bool> signInAsGuest() => _executer(_repository.signInAsGuest);

  Future<bool> elevate({required String pseudo, required String password}) {
    final String? erreur = erreurValidationElevation(pseudo, password);
    if (erreur != null) {
      _setOperation(OperationFailed(erreur));
      return Future<bool>.value(false);
    }
    return _executer(
      () => _repository.elevate(pseudo: pseudo.trim(), password: password),
    );
  }

  Future<bool> signIn({required String pseudo, required String password}) {
    final String? erreur = erreurValidationElevation(pseudo, password);
    if (erreur != null) {
      _setOperation(OperationFailed(erreur));
      return Future<bool>.value(false);
    }
    return _executer(
      () => _repository.signIn(pseudo: pseudo.trim(), password: password),
    );
  }

  Future<bool> signOut() => _executer(_repository.signOut);

  @override
  void dispose() {
    _abonnement.cancel();
    _sessions.close();
    super.dispose();
  }
}
