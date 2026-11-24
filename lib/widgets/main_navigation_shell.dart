import 'package:avis/Helpers/navigators.dart';
import 'package:avis/Screens/feed_screen.dart';
import 'package:avis/Screens/user_profil_screen.dart';
import 'package:avis/widgets/bottom_nav_bar_widget.dart';
import 'package:flutter/material.dart';

/// Coque unique des deux onglets principaux.
///
/// Le feed et le profil sont montés une seule fois dans un [IndexedStack] :
/// changer d'onglet ne pousse pas de route et ne reconstruit pas l'autre page.
/// Scaffold, barre basse et FAB appartiennent à cette coque, pas aux écrans.
/// Les écrans de création et de résultat restent, eux, de vraies routes poussées.
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _index = 0;
  bool _profilVisite = false;

  void _changerOnglet(int index) {
    if (index == _index) return;
    setState(() {
      _index = index;
      // Le profil n'est construit qu'à la première sélection : il garde ensuite
      // son état dans l'IndexedStack, comme le feed.
      if (index == 1) _profilVisite = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CreateDuelFab(
        onPressed: () => demanderElevation(
          context,
          action: () async => naviguerNewPostScreen(context),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: _index,
        onFeed: () => _changerOnglet(0),
        onProfil: () => _changerOnglet(1),
      ),
      body: IndexedStack(
        index: _index,
        children: [
          const FeedScreen(),
          if (_profilVisite) const UserProfilScreen() else const SizedBox.shrink(),
        ],
      ),
    );
  }
}
