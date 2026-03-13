abstract class AuthHelper<T> {
  Future createUserWithEmail(String email, String password);
  Future signInUserWithGoogle();
  Future signInUserAnonynously();
  Future signInUserWithEmail(String email, String password);
  Future signOut();
}
