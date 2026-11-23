import 'package:avis/Providers/auth_services_providers.dart';
import 'package:avis/Providers/interactions_services_provider.dart';
import 'package:avis/Providers/post_table_proider.dart';
import 'package:avis/Providers/profile_table_provider.dart';
import 'package:avis/Screens/new_post_screen.dart';
import 'package:avis/widgets/bottom_nav_bar_widget.dart';
import 'package:avis/widgets/main_navigation_shell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../fixtures/fakes.dart';

class ObservateurNavigation extends NavigatorObserver {
  int pushes = 0;

  @override
  void didPush(Route route, Route? previousRoute) {
    pushes++;
  }
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<ObservateurNavigation> pomperShell(WidgetTester tester) async {
    final FakePostsTableServices posts = FakePostsTableServices();
    final FakeAuthRepository depot = FakeAuthRepository();
    final AuthServicesProviders auth = AuthServicesProviders(repository: depot);
    depot.devenirAuthentifie();
    addTearDown(posts.close);
    addTearDown(depot.close);
    addTearDown(auth.dispose);

    final ObservateurNavigation observateur = ObservateurNavigation();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => PostTableProider(
              postsTableServices: posts,
              storageServices: FakeStorageServices(),
            ),
          ),
          ChangeNotifierProvider(
            create: (_) =>
                InteractionsServicesProvider(interactions: FakeInteractionsServices()),
          ),
          ChangeNotifierProvider.value(value: auth),
          ChangeNotifierProvider(
            create: (_) => ProfileTableProvider(
              profileTableServices: FakeProfileTableServices(),
            ),
          ),
        ],
        child: MaterialApp(
          navigatorObservers: [observateur],
          home: const MainNavigationShell(),
        ),
      ),
    );
    await posts.emit([buildPost()]);
    await tester.pumpAndSettle();
    // La route initiale est elle aussi annoncée à l'observateur : on ne compte
    // que les poussées déclenchées par les interactions du test.
    observateur.pushes = 0;
    return observateur;
  }

  testWidgets('une seule barre et un seul FAB portés par le shell', (tester) async {
    await pomperShell(tester);

    expect(find.byType(MainNavigationShell), findsOneWidget);
    expect(find.byType(BottomNavBarWidget), findsOneWidget);
    expect(find.byType(CupertinoTabBar), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(
      tester.widget<CupertinoTabBar>(find.byType(CupertinoTabBar)).currentIndex,
      0,
    );
  });

  testWidgets('changer d onglet ne pousse aucune route', (tester) async {
    final ObservateurNavigation observateur = await pomperShell(tester);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();

    expect(observateur.pushes, 0);
    expect(
      tester.widget<CupertinoTabBar>(find.byType(CupertinoTabBar)).currentIndex,
      1,
    );
    expect(find.byType(MainNavigationShell), findsOneWidget);

    await tester.tap(find.text('Feed'));
    await tester.pumpAndSettle();

    expect(observateur.pushes, 0);
    expect(
      tester.widget<CupertinoTabBar>(find.byType(CupertinoTabBar)).currentIndex,
      0,
    );
  });

  testWidgets('le FAB, lui, reste une route de création', (tester) async {
    final ObservateurNavigation observateur = await pomperShell(tester);

    await tester.tap(find.byTooltip('Créer un duel'));
    await tester.pumpAndSettle();

    expect(observateur.pushes, 1);
    expect(find.byType(NewPostScreen), findsOneWidget);
  });
}
