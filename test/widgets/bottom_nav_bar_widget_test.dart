import 'package:avis/constants.dart';
import 'package:avis/widgets/bottom_nav_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget app({
    int currentIndex = 0,
    required VoidCallback onFeed,
    required VoidCallback onCreer,
    required VoidCallback onProfil,
  }) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: CreateDuelFab(onPressed: onCreer),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavBarWidget(
          currentIndex: currentIndex,
          onFeed: onFeed,
          onProfil: onProfil,
        ),
      ),
    );
  }

  testWidgets('deux onglets : Feed à gauche, + au centre, Profil à droite', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(onFeed: () {}, onCreer: () {}, onProfil: () {}),
    );

    expect(find.text('Feed'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
    expect(find.byTooltip('Créer un duel'), findsOneWidget);
    expect(find.text('Menu'), findsNothing);
    expect(find.text('Déconnecter'), findsNothing);

    final double feedX = tester.getCenter(find.text('Feed')).dx;
    final double fabX = tester.getCenter(find.byTooltip('Créer un duel')).dx;
    final double profilX = tester.getCenter(find.text('Profil')).dx;
    expect(feedX, lessThan(fabX));
    expect(fabX, lessThan(profilX));
  });

  testWidgets('chaque destination appelle une seule action', (tester) async {
    int feed = 0;
    int creer = 0;
    int profil = 0;

    await tester.pumpWidget(
      app(
        onFeed: () => feed++,
        onCreer: () => creer++,
        onProfil: () => profil++,
      ),
    );

    await tester.tap(find.text('Feed'));
    await tester.tap(find.byTooltip('Créer un duel'));
    await tester.tap(find.text('Profil'));
    await tester.pump();

    expect(feed, 1);
    expect(creer, 1);
    expect(profil, 1);
  });

  testWidgets('la barre est un CupertinoTabBar aux couleurs du projet', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(onFeed: () {}, onCreer: () {}, onProfil: () {}),
    );

    final CupertinoTabBar nav = tester.widget<CupertinoTabBar>(
      find.byType(CupertinoTabBar),
    );
    expect(nav.currentIndex, 0);
    expect(nav.items.map((item) => item.label), ['Feed', 'Profil']);
    expect(nav.activeColor, teal);
    expect(nav.inactiveColor, texteSecondaire);
    expect(nav.backgroundColor, blanc);
    expect(nav.height, 64);
    // Le trait est dessiné par-dessus le ClipRRect pour suivre les deux coins.
    expect(nav.border, isNull);
    final ClipRRect clip = tester.widget<ClipRRect>(
      find.ancestor(
        of: find.byType(CupertinoTabBar),
        matching: find.byType(ClipRRect),
      ),
    );
    final BorderRadius rayons = clip.borderRadius as BorderRadius;
    expect(rayons.topLeft.x, rayonCarte);
    expect(rayons.topRight.x, rayonCarte);
    expect(rayons.bottomLeft, Radius.zero);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('sur le profil, la barre sélectionne Profil', (tester) async {
    await tester.pumpWidget(
      app(
        currentIndex: 1,
        onFeed: () {},
        onCreer: () {},
        onProfil: () {},
      ),
    );

    final CupertinoTabBar nav = tester.widget<CupertinoTabBar>(
      find.byType(CupertinoTabBar),
    );
    expect(nav.currentIndex, 1);
  });

  testWidgets('le + est un FAB teal sans héros partagé', (tester) async {
    await tester.pumpWidget(
      app(onFeed: () {}, onCreer: () {}, onProfil: () {}),
    );

    final FloatingActionButton fab = tester.widget<FloatingActionButton>(
      find.byType(FloatingActionButton),
    );
    expect(fab.tooltip, 'Créer un duel');
    expect(fab.backgroundColor, teal);
    expect(fab.foregroundColor, blanc);
    expect(fab.elevation, greaterThan(0));
    expect(fab.heroTag, isNull);
  });
}
