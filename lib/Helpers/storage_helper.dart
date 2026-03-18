abstract class StorageHelper<T> {
  Future addData(T item);
  Future updateData(T item);
  Future deletedata(T item);
  Future readDataOnce(String id);
}
