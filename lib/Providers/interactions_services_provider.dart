import 'package:avis/Helpers/pourcentage.dart';
import 'package:avis/Models/interaction.dart';
import 'package:avis/Services/Supabase/interactions_services.dart';
import 'package:flutter/material.dart';

class InteractionsServicesProvider extends ChangeNotifier {
  final InteractionsServices _interactions;

  InteractionsServicesProvider({InteractionsServices? interactions})
      : _interactions = interactions ?? InteractionsServices();

  Future addInteraction({required Interaction interaction}) async {
    try {
      await _interactions.addData(interaction);
    } catch (e) {
      debugPrint("Erreur lors de l'enregistrement de l'interaction : $e");
    }
  }

  Future<List<Interaction>?> readInteractions({required int postId}) async {
    try {
      return await _interactions.readDataOnce(postId);
    } catch (e) {
      return null;
    }
  }

  Future<InteractionWithCount>? readUserInteractions({
    required String userId,
  }) {
    try {
      return _interactions.readUserData(userId);
    } catch (e) {
      return null;
    }
  }

  Future<double> optionAPourcentage(int postId) async {
    final List<Interaction> allInteractions = await _interactions.readDataOnce(
      postId,
    );
    final int optionA = allInteractions
        .where((element) => element.choix == "A")
        .length;
    return calculerPourcentage(optionA, allInteractions.length);
  }

  Future<double> optionBPourcentage(int postId) async {
    final List<Interaction> allInteractions = await _interactions.readDataOnce(
      postId,
    );
    final int optionB = allInteractions
        .where((element) => element.choix == "B")
        .length;
    return calculerPourcentage(optionB, allInteractions.length);
  }
}
