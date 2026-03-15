import 'dart:io';

import 'package:avis/Helpers/database_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageServices implements DatabaseHelper<File> {
  final _supabase = Supabase.instance.client;

  @override
  Future<String> addData(File item) {
    return _supabase.storage.from('images').upload("images/", item);
  }

  @override
  Future<dynamic> deletedata(File item) {
    // TODO: implement deletedata
    throw UnimplementedError();
  }

  @override
  Stream<List<File>> readData() {
    // TODO: implement readData
    throw UnimplementedError();
  }

  @override
  Future<dynamic> readDataOnce(String id) {
    // TODO: implement readDataOnce
    throw UnimplementedError();
  }

  @override
  Future<dynamic> updateData(File item) {
    // TODO: implement updateData
    throw UnimplementedError();
  }
}
