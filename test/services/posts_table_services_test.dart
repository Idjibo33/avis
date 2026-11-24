import 'dart:async';

import 'package:avis/Services/serverpod/posts_table_services.dart';
import 'package:avis_client/avis_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_client/serverpod_client.dart' as isc;

Duel _duel() => Duel(
  id: 1,
  authorId: isc.UuidValue.fromString('01a2040b-6f5c-7c20-8ac8-e989df3d56f2'),
  authorName: 'Joueur',
  question: 'Montagne ou plage ?',
  type: 'text',
);

Future<void> _microtache() => Future<void>.delayed(Duration.zero);

void main() {
  test('le second abonné reçoit le dernier feed sans nouvelle requête', () async {
    int appels = 0;
    final PostsTableServices services = PostsTableServices(
      chargeur: () async {
        appels++;
        return [_duel()];
      },
    );

    final List<List<dynamic>> premier = [];
    final StreamSubscription<dynamic> abonnement = services.readData().listen(
      premier.add,
    );
    await _microtache();

    expect(appels, 1);
    expect(premier, hasLength(1));
    expect(premier.single, hasLength(1));

    final List<List<dynamic>> second = [];
    final StreamSubscription<dynamic> secondAbonnement = services
        .readData()
        .listen(second.add);
    await _microtache();

    // Régression : `onListen` d'un contrôleur broadcast ne s'appelle que pour
    // le premier abonné. Le cache doit être rejoué par le flux de chaque
    // lecteur, sinon le profil ouvert après le feed reste sur son spinner.
    expect(appels, 1);
    expect(second, hasLength(1));
    expect(second.single.first.question, 'Montagne ou plage ?');

    await abonnement.cancel();
    await secondAbonnement.cancel();
  });

  test('une erreur vide le cache pour que le réessai recharge', () async {
    bool echec = true;
    final PostsTableServices services = PostsTableServices(
      chargeur: () async {
        if (echec) throw Exception('boom');
        return [_duel()];
      },
    );

    Object? erreur;
    final StreamSubscription<dynamic> abonnement = services.readData().listen(
      (_) {},
      onError: (Object e) => erreur = e,
    );
    await _microtache();
    expect(erreur, isNotNull);
    await abonnement.cancel();

    echec = false;
    List<dynamic>? donnees;
    final StreamSubscription<dynamic> nouvelAbonnement = services
        .readData()
        .listen((dynamic recu) => donnees = recu);
    await _microtache();

    expect(donnees, hasLength(1));
    await nouvelAbonnement.cancel();
  });
}
