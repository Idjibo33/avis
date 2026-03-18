import 'package:avis/Helpers/interaction_table_helper.dart';
import 'package:avis/Models/interaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InteractionsServices extends InteractionTableHelper<Interaction> {
  final _supabase = Supabase.instance.client;
  final table = "interactions";
  @override
  Future<dynamic> addData(item) {
    final data = {'post': item.postId, 'choix': item.choix};
    return _supabase.from(table).insert(data);
  }

  @override
  Future<dynamic> deletedata(item) {
    // TODO: implement deletedata
    throw UnimplementedError();
  }

  @override
  Future<List<Interaction>> readDataOnce(int postId) {
    return _supabase
        .from(table)
        .select()
        .eq('post', postId)
        .withConverter(
          (data) => data.map((e) => Interaction.fromMap(e)).toList(),
        );
  }

  @override
  Future<dynamic> updateData(item) {
    // TODO: implement updateData
    throw UnimplementedError();
  }

  @override
  Stream<List<Interaction>> readData() {
    // TODO: implement readData
    throw UnimplementedError();
  }
}
