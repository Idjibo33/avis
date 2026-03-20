abstract class PostTableHelper<T> {
  Future addData(T item);
  Future updateData(T item);
  Future deletedata(T item);
  Stream getUserPosts(String userId);
}
