import 'package:avis/Models/interaction.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fakes.dart';

void main() {
  test('aucune interaction : pourcentages à 0 sans NaN', () async {
    final FakeInteractionsServices services = FakeInteractionsServices();
    final InteractionsServicesProvider provider =
        InteractionsServicesProvider(interactions: services);

    expect(await provider.optionAPourcentage(1), 0);
    expect(await provider.optionBPourcentage(1), 0);
  });

  test('pourcentages calculés sur les choix réels', () async {
    final FakeInteractionsServices services = FakeInteractionsServices()
      ..interactions = [
        Interaction(choix: 'A', postId: 1),
        Interaction(choix: 'A', postId: 1),
        Interaction(choix: 'B', postId: 1),
        Interaction(choix: 'A', postId: 1),
      ];
    final InteractionsServicesProvider provider =
        InteractionsServicesProvider(interactions: services);

    expect(await provider.optionAPourcentage(1), 75);
    expect(await provider.optionBPourcentage(1), 25);
  });
}
