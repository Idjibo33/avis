import 'dart:math' as math;

import 'package:avis/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Barre basse du shell : deux onglets au style Cupertino.
///
/// Elle n'est instanciée qu'une fois, par [MainNavigationShell], et ne pousse
/// aucune route : les onglets basculent l'index du shell. Le « + » n'est pas un
/// onglet : c'est un [FloatingActionButton] porté par le même Scaffold (voir
/// [CreateDuelFab]), ancré au centre de cette barre.
class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onFeed,
    required this.onProfil,
  });

  /// 0 = Feed, 1 = Profil. La barre n'est portée que par le shell.
  final int currentIndex;
  final VoidCallback onFeed;
  final VoidCallback onProfil;

  // Icônes Material : déjà embarquées par `uses-material-design: true`, sans
  // dépendance ni police supplémentaire pour le build web.
  static const List<BottomNavigationBarItem> _destinations = [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      activeIcon: Icon(Icons.dashboard),
      label: 'Feed',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Le rayon extérieur reprend celui des cartes : la barre est une surface
    // du même système que le reste de l'interface. Le trait supérieur est
    // dessiné par-dessus pour suivre les deux coins arrondis.
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(rayonCarte),
      ),
      child: Stack(
        children: [
          CupertinoTabBar(
            currentIndex: currentIndex,
            items: _destinations,
            onTap: (int index) => switch (index) {
              0 => onFeed(),
              _ => onProfil(),
            },
            backgroundColor: blanc,
            activeColor: teal,
            inactiveColor: texteSecondaire,
            iconSize: 22,
            height: 64,
            // Tracé par _BordureHauteArrondie : une bordure rectangulaire serait
            // coupée par le ClipRRect et disparaîtrait aux deux coins.
            border: null,
          ),
          const Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _BordureHauteArrondie()),
            ),
          ),
        ],
      ),
    );
  }
}

/// Trait supérieur de la barre, arqué sur les deux coins.
class _BordureHauteArrondie extends CustomPainter {
  const _BordureHauteArrondie();

  @override
  void paint(Canvas canvas, Size size) {
    final Path bordure = Path()
      ..moveTo(0, rayonCarte)
      ..arcTo(
        Rect.fromCircle(center: Offset(rayonCarte, rayonCarte), radius: rayonCarte),
        math.pi,
        math.pi / 2,
        false,
      )
      ..lineTo(size.width - rayonCarte, 0)
      ..arcTo(
        Rect.fromCircle(
          center: Offset(size.width - rayonCarte, rayonCarte),
          radius: rayonCarte,
        ),
        3 * math.pi / 2,
        math.pi / 2,
        false,
      );

    canvas.drawPath(
      bordure,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = bordureNeutre
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _BordureHauteArrondie oldDelegate) => false;
}

/// Bouton flottant « + » du centre : une action, pas un onglet.
///
/// Le `heroTag: null` évite un conflit de héros pendant la transition entre le
/// feed et le profil, qui restent tous les deux montés dans le shell.
class CreateDuelFab extends StatelessWidget {
  const CreateDuelFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: onPressed,
      tooltip: 'Créer un duel',
      backgroundColor: teal,
      foregroundColor: blanc,
      elevation: 4,
      child: const Icon(Icons.add),
    );
  }
}
