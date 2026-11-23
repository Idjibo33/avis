import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palette volontairement limitée à trois couleurs : noir, blanc et teal.
/// Les gris ne sont que des teintes de noir (surfaces et texte secondaire).
const Color noir = Color(0xFF0A0A0A);
const Color blanc = Color(0xFFFFFFFF);
const Color teal = Color(0xFF0F766E);

const Color texteSecondaire = Color(0xFF595959);
const Color surfaceNeutre = Color(0xFFF3F5F5);
const Color bordureNeutre = Color(0xFFD8DEDE);

/// Rythme d'espacement 4/8/12/16/24, en dp.
const double espaceXs = 4;
const double espaceSm = 8;
const double espaceMd = 12;
const double espaceLg = 16;
const double espaceXl = 24;

/// Rayons concentriques : carte 24, contenu 16, champ 12.
const double rayonCarte = 24;
const double rayonInterne = 16;
const double rayonChamp = 12;

/// Anciens noms conservés pour ne pas casser les imports existants.
/// L'option A est noire, l'option B est teal.
const Color couleureBleue = noir;
const Color couleureRose = teal;
final Color backgroundCouleureBleue = noir.withValues(alpha: 0.08);
final Color backgroundCouleureRose = teal.withValues(alpha: 0.12);

/// Une seule famille typographique, neutre et lisible : Inter.
final TextStyle textTitreStyle = GoogleFonts.inter(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: noir,
  letterSpacing: -0.2,
  height: 1.25,
);

final TextStyle textCorpsStyle = GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: texteSecondaire,
  height: 1.4,
);

/// Chiffres à largeur fixe pour compteurs, pourcentages et totaux : la valeur
/// ne fait plus varier la largeur du texte lors d'un rafraîchissement.
final TextStyle textChiffresStyle = textTitreStyle.copyWith(
  fontFeatures: const [FontFeature.tabularFigures()],
);
