enum AuthSessionStatus { unknown, guest, authenticated, failed }

class AuthSessionState {
  const AuthSessionState({
    required this.status,
    this.authUserId,
    this.pseudo,
    this.error,
  });

  final AuthSessionStatus status;
  final String? authUserId;
  final String? pseudo;
  final Object? error;
}

abstract class AuthRepository {
  Stream<AuthSessionState> get state;
  AuthSessionState get current;
  Future<void> initialize();
  Future<void> signInAsGuest();
  Future<void> elevate({required String pseudo, required String password});
  Future<void> signIn({required String pseudo, required String password});
  Future<void> signOut();
}
