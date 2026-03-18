import 'dart:io';

import 'package:avis/Helpers/interaction_table_helper.dart';
import 'package:avis/Helpers/storage_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageServices implements StorageHelper<File> {
  final _supabase = Supabase.instance.client;

  @override
  Future<String> addData(File item) async {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpb";
    final path = "posts/$userId/$fileName";
    await _supabase.storage.from('images').upload(path, item);
    return _supabase.storage.from('images').getPublicUrl(path);
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
