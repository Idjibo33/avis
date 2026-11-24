import 'package:avis/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

/// Marque d'Avis : disque noir, couches blanches et point teal.
///
/// `size` est le **diamètre** du disque. Le point est entièrement contenu dans
/// ce diamètre (aucun débordement, même dans une AppBar de faible hauteur).
/// Cette géométrie est la même que celle utilisée pour générer les icônes
/// launcher (voir `docs/ui-design.md`).
class Logo extends StatelessWidget {
  final double size;

  /// Affiche le mot « avis » à côté du disque (en-tête du feed).
  final bool avecTexte;

  const Logo({super.key, required this.size, this.avecTexte = false});

  @override
  Widget build(BuildContext context) {
    final double point = size * 0.30;
    final double marge = size * 0.035;

    final Widget marque = Semantics(
      label: 'Avis',
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(color: noir, shape: BoxShape.circle),
            ),
            FaIcon(
              FontAwesomeIcons.layerGroup,
              size: size * 0.52,
              color: blanc,
            ),
            Positioned(
              top: marge,
              right: marge,
              child: Container(
                width: point,
                height: point,
                decoration: BoxDecoration(
                  color: teal,
                  shape: BoxShape.circle,
                  border: Border.all(color: blanc, width: size * 0.045),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (!avecTexte) return marque;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        marque,
        SizedBox(width: espaceSm),
        Text(
          'avis',
          style: GoogleFonts.inter(
            fontSize: size * 0.58,
            fontWeight: FontWeight.w800,
            color: noir,
            letterSpacing: -0.6,
          ),
        ),
      ],
    );
  }
}
