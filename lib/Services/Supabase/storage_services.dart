import 'package:avis/Helpers/storage_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageServices implements StorageHelper<XFile> {
  final _supabase = Supabase.instance.client;

  @override
  Future<String> addData(XFile item) async {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
    final path = "posts/$userId/$fileName";
    final bytes = await item.readAsBytes();
    await _supabase.storage.from('images').uploadBinary(path, bytes);
    return _supabase.storage.from('images').getPublicUrl(path);
  }

  @override
  Future<dynamic> deletedata(XFile item) {
    // TODO: implement deletedata
    throw UnimplementedError();
  }

  @override
  Future<dynamic> readDataOnce(String id) {
    // TODO: implement readDataOnce
    throw UnimplementedError();
  }

  @override
  Future<dynamic> updateData(XFile item) {
    // TODO: implement updateData
    throw UnimplementedError();
  }
}
