import 'package:avis/Models/interaction.dart';
import 'package:avis/Services/Supabase/interactions_services.dart';
import 'package:flutter/material.dart';

class InteractionsServicesProvider extends ChangeNotifier {
  final InteractionsServices _interactions = InteractionsServices();
  Future addInteraction({required Interaction interaction}) async {
    try {
      await _interactions.addData(interaction);
    } catch (e) {}
  }

  Future<List<Interaction>?> readInteractions({required int postId}) async {
    try {
      return await _interactions.readDataOnce(postId);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
