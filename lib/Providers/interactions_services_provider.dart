import 'package:avis/Helpers/pourcentage.dart';
import 'package:avis/Models/interaction.dart';
import 'package:avis/Services/serverpod/interactions_services.dart';
import 'package:flutter/material.dart';

class InteractionsServicesProvider extends ChangeNotifier {
  final InteractionsServices _interactions;

  InteractionsServicesProvider({InteractionsServices? interactions})
    : _interactions = interactions ?? InteractionsServices();

  /// Renvoie explicitement le succès de l'écriture : les écrans ne doivent pas
  /// annoncer un vote enregistré quand le backend a refusé l'interaction.
  Future<bool> addInteraction({required Interaction interaction}) async {
    try {
      await _interactions.addData(interaction);
      return true;
    } catch (e) {
      debugPrint("Erreur lors de l'enregistrement de l'interaction : $e");
      return false;
    }
  }

  Future<List<Interaction>?> readInteractions({required int postId}) async {
    try {
      return await _interactions.readDataOnce(postId);
    } catch (e) {
      return null;
    }
  }

  Future<InteractionWithCount>? readUserInteractions({required String userId}) {
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
