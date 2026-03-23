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
    List<Interaction> allInteractions = await _interactions.readDataOnce(
      postId,
    );
    List<Interaction> optionA = [];
    for (var i in allInteractions.where((element) => element.choix == "A")) {
      optionA.add(i);
    }
    var resultat = (optionA.length / allInteractions.length) * 100;
    return resultat;
  }

  Future<double> optionBPourcentage(int postId) async {
    List<Interaction> allInteractions = await _interactions.readDataOnce(
      postId,
    );
    List<Interaction> optionB = [];
    for (var i in allInteractions.where((element) => element.choix == "B")) {
      optionB.add(i);
    }
    var resultat = (optionB.length / allInteractions.length) * 100;
    return resultat;
  }
}
