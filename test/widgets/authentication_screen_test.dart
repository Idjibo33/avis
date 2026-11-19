import 'package:avis/Helpers/navigators.dart';
import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Screens/authentication_screen.dart';
import 'package:avis/Services/auth_repository.dart';
import 'package:avis/State/auth_gate_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<(FakeAuthRepository, AuthElevationController, BuildContext)> pumpHote(
    WidgetTester tester,
  ) async {
    final FakeAuthRepository repository = FakeAuthRepository();
    final AuthElevationController controller = AuthElevationController();
    addTearDown(repository.close);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthServicesProviders(repository: repository),
          ),
          ChangeNotifierProvider.value(value: controller),
        ],
        child: const MaterialApp(home: Scaffold(body: SizedBox.expand())),
      ),
    );
    final BuildContext context = tester.element(find.byType(Scaffold));
    // Le provider Provider est paresseux : on le force à s'abonner avant de
    // publier l'état invité, comme le ferait l'adaptateur Serverpod.
    Provider.of<AuthServicesProviders>(context, listen: false);
    repository.devenirInvite();
    await tester.pumpAndSettle();
    return (repository, controller, context);
  }

  Future<void> saisir(
    WidgetTester tester,
    String pseudo,
    String password,
  ) async {
    await tester.enterText(find.byType(TextField).at(0), pseudo);
    await tester.enterText(find.byType(TextField).at(1), password);
  }

  testWidgets(
    'la feuille s ouvre au-dessus du contenu avec un seul formulaire',
    (tester) async {
      final (_, _, BuildContext context) = await pumpHote(tester);

      final Future<bool> ouverture = AuthenticationScreen.ouvrir(context);
      await tester.pumpAndSettle();

      expect(find.byType(AuthenticationScreen), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Connexion'), findsNothing);
      expect(find.text('Inscription'), findsNothing);
      expect(find.text('Email'), findsNothing);

      await tester.tap(find.byTooltip('Fermer'));
      await tester.pumpAndSettle();
      expect(await ouverture, isFalse);
      expect(find.byType(AuthenticationScreen), findsNothing);
    },
  );

  testWidgets('échec avec identifiant invité : élévation toujours possible', (
    tester,
  ) async {
    final (FakeAuthRepository repository, _, BuildContext context) =
        await pumpHote(tester);
    repository.emit(
      const AuthSessionState(
        status: AuthSessionStatus.failed,
        authUserId: 'invite-1',
        error: 'refus serveur',
      ),
    );
    await tester.pumpAndSettle();

    final Future<bool> demande = demanderElevation(context);
    await tester.pumpAndSettle();

    expect(find.byType(AuthenticationScreen), findsOneWidget);
    await tester.tap(find.byTooltip('Fermer'));
    await tester.pumpAndSettle();
    expect(await demande, isFalse);
  });

  testWidgets(
    'write sans AuthElevationController : pas de plantage silencieux',
    (tester) async {
      final FakeAuthRepository repository = FakeAuthRepository();
      addTearDown(repository.close);
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AuthServicesProviders(repository: repository),
          child: const MaterialApp(home: Scaffold(body: SizedBox.expand())),
        ),
      );
      final BuildContext context = tester.element(find.byType(Scaffold));
      Provider.of<AuthServicesProviders>(context, listen: false);
      repository.devenirInvite();
      await tester.pumpAndSettle();

      int appels = 0;
      final Future<bool> demande = demanderElevation(
        context,
        action: () async {
          appels++;
        },
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(AuthenticationScreen), findsOneWidget);

      await tester.tap(find.byTooltip('Fermer'));
      await tester.pumpAndSettle();

      expect(await demande, isFalse);
      expect(appels, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'sans AuthServicesProviders : repli visible, aucune feuille ni écriture',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SizedBox.expand())),
      );
      final BuildContext context = tester.element(find.byType(Scaffold));

      int appels = 0;
      final bool reussi = await demanderElevation(
        context,
        action: () async {
          appels++;
        },
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(reussi, isFalse);
      expect(appels, 0);
      expect(find.byType(AuthenticationScreen), findsNothing);
      expect(find.text('Action indisponible pour le moment.'), findsOneWidget);
    },
  );

  testWidgets('pseudo court et mot de passe court : saisie conservée', (
    tester,
  ) async {
    final (FakeAuthRepository repository, _, BuildContext context) =
        await pumpHote(tester);
    final Future<bool> demande = demanderElevation(context);
    await tester.pumpAndSettle();

    await saisir(tester, 'ab', 'court');
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Le pseudo doit contenir entre 3 et 20 lettres, chiffres ou tirets bas.',
      ),
      findsOneWidget,
    );
    expect(repository.elevateCalls, 0);
    expect(find.byType(AuthenticationScreen), findsOneWidget);

    await saisir(tester, 'joueur_1', 'court');
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(
      find.text('Le mot de passe doit contenir au moins 8 caractères.'),
      findsOneWidget,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
      'joueur_1',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
      'court',
    );

    await tester.tap(find.byTooltip('Fermer'));
    await tester.pumpAndSettle();
    expect(await demande, isFalse);
  });

  testWidgets('succès : la feuille se ferme et l action reprend', (
    tester,
  ) async {
    final (FakeAuthRepository repository, _, BuildContext context) =
        await pumpHote(tester);
    int appels = 0;
    final Future<bool> demande = demanderElevation(
      context,
      action: () async {
        appels++;
      },
    );
    await tester.pumpAndSettle();

    await saisir(tester, 'joueur_1', 'motdepasse1');
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(await demande, isTrue);
    expect(appels, 1);
    expect(repository.dernierPseudo, 'joueur_1');
    expect(find.byType(AuthenticationScreen), findsNothing);
  });

  testWidgets('échec : invité, saisies conservées, réessai possible', (
    tester,
  ) async {
    final (
      FakeAuthRepository repository,
      AuthElevationController controller,
      BuildContext context,
    ) = await pumpHote(
      tester,
    );
    int appels = 0;
    repository.erreurElevation = Exception('Identifiants refusés');
    final Future<bool> demande = demanderElevation(
      context,
      action: () async {
        appels++;
      },
    );
    await tester.pumpAndSettle();

    await saisir(tester, 'joueur_1', 'motdepasse1');
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Identifiants refusés'), findsOneWidget);
    expect(find.byType(AuthenticationScreen), findsOneWidget);
    expect(controller.aUneActionEnAttente, isTrue);
    expect(appels, 0);
    expect(
      tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
      'joueur_1',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
      'motdepasse1',
    );

    repository.erreurElevation = null;
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(await demande, isTrue);
    expect(appels, 1);
    expect(find.byType(AuthenticationScreen), findsNothing);
  });
}
