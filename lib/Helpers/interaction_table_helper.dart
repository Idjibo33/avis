abstract class InteractionTableHelper<T> {
  Future addData(T item);
  Future updateData(T item);
  Future deletedata(T item);
  Future readDataOnce(int postId);
  Future readUserData(String userId);
}
