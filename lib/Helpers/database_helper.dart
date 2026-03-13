abstract class DatabaseHelper<T> {
  Future addData(T item);
  Future updateData(T item);
  Future deletedata(T item);
  Future readDataOnce(String id);
  Stream<List<T>> readData();
}
