import 'package:avis/Helpers/profiles_table_helper.dart';
import 'package:avis/Models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileTableServices implements ProfilesTableHelper<Profile> {
  final _supabase = Supabase.instance.client;
  final table = "profiles";
  @override
  Future<dynamic> addData(Profile item) {
    final data = {'nom': item.nom, 'prenom': item.prenom, 'email': item.email};
    return _supabase.from(table).insert(data);
  }

  @override
  Future<dynamic> deletedata(Profile item) {
    return _supabase.from(table).delete().eq('id', item.id!);
  }

  @override
  Stream<List<Profile>> readData() {
    return _supabase.from(table).stream(primaryKey: ['id']).map((event) {
      return event.map((e) => Profile.fromMap(e)).toList();
    });
  }

  @override
  Future<Profile> readDataOnce(String id) {
    final resultat = _supabase.from(table).select().eq('id', id).single();
    return resultat.withConverter((data) => Profile.fromMap(data));
  }

  @override
  Future<dynamic> updateData(Profile item) {
    final data = {'nom': item.nom, 'prenom': item.prenom, 'email': item.email};
    return _supabase.from(table).update(data).eq('id', item.id!);
  }
}
