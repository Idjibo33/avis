import 'package:avis/Helpers/auth_helper.dart';
import 'package:avis/Models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices implements AuthHelper<Profile> {
  final _supabase = Supabase.instance.client;

  Stream<AuthState> get authState => _supabase.auth.onAuthStateChange;

  @override
  Future<dynamic> createUserWithEmail(email, password) {
    return _supabase.auth.signUp(email: email, password: password);
  }

  @override
  Future<dynamic> signInUserAnonynously() {
    return _supabase.auth.signInAnonymously();
  }

  @override
  Future<dynamic> signInUserWithEmail(String email, String password) {
    return _supabase.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<dynamic> signInUserWithGoogle() {
    // TODO: implement signInUserWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<dynamic> signOut() {
    return _supabase.auth.signOut();
  }
}
