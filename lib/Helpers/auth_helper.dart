abstract class AuthHelper<T> {
  Future createUserWithEmail(T user);
  Future createUserAnonynously();
  Future updateUser(T user);
  Future deleteuser(T user);
}
