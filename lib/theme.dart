import 'package:avis/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Thème unique de l'application : fond blanc, texte noir, accent teal.
/// Toutes les surfaces et tous les états sont définis ici plutôt que dans
/// les écrans, afin qu'un changement de palette ne touche qu'un seul fichier.
ThemeData appTheme() {
  final ColorScheme scheme = ColorScheme.fromSeed(seedColor: teal).copyWith(
    primary: teal,
    onPrimary: blanc,
    primaryContainer: backgroundCouleureRose,
    onPrimaryContainer: teal,
    secondary: noir,
    onSecondary: blanc,
    secondaryContainer: surfaceNeutre,
    onSecondaryContainer: noir,
    tertiary: teal,
    onTertiary: blanc,
    error: noir,
    onError: blanc,
    errorContainer: surfaceNeutre,
    onErrorContainer: noir,
    surface: blanc,
    onSurface: noir,
    surfaceTint: blanc,
    surfaceContainerLowest: blanc,
    surfaceContainerLow: blanc,
    surfaceContainer: surfaceNeutre,
    surfaceContainerHigh: surfaceNeutre,
    surfaceContainerHighest: surfaceNeutre,
    onSurfaceVariant: texteSecondaire,
    outline: bordureNeutre,
    outlineVariant: bordureNeutre,
    shadow: noir,
    scrim: noir.withValues(alpha: 0.55),
    inverseSurface: noir,
    onInverseSurface: blanc,
    inversePrimary: teal,
  );

  final BorderRadius rayonChampBordure = BorderRadius.circular(rayonChamp);
  final BorderSide bordure = BorderSide(color: bordureNeutre);
  final TextStyle styleBouton = textTitreStyle.copyWith(
    fontSize: 14,
    color: blanc,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: blanc,
    fontFamily: GoogleFonts.inter().fontFamily,
    iconTheme: const IconThemeData(color: noir, size: 24),
    appBarTheme: AppBarTheme(
      backgroundColor: blanc,
      surfaceTintColor: blanc,
      foregroundColor: noir,
      iconTheme: const IconThemeData(color: noir, size: 24),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: textTitreStyle.copyWith(fontSize: 18),
      shape: const Border(bottom: BorderSide(color: bordureNeutre)),
    ),
    cardTheme: CardThemeData(
      color: blanc,
      surfaceTintColor: blanc,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rayonCarte),
        side: bordure,
      ),
    ),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: rayonChampBordure),
      minTileHeight: 48,
      contentPadding: const EdgeInsets.symmetric(horizontal: espaceMd),
      iconColor: noir,
      titleTextStyle: textTitreStyle.copyWith(fontSize: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: teal,
        foregroundColor: blanc,
        disabledBackgroundColor: surfaceNeutre,
        disabledForegroundColor: texteSecondaire,
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: rayonChampBordure),
        textStyle: styleBouton,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: blanc,
        foregroundColor: noir,
        disabledBackgroundColor: surfaceNeutre,
        disabledForegroundColor: texteSecondaire,
        elevation: 0,
        minimumSize: const Size(48, 48),
        side: const BorderSide(color: noir),
        shape: RoundedRectangleBorder(borderRadius: rayonChampBordure),
        textStyle: styleBouton.copyWith(color: noir),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: teal,
        minimumSize: const Size(48, 48),
        textStyle: styleBouton,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceNeutre,
      hintStyle: textCorpsStyle,
      labelStyle: textCorpsStyle,
      floatingLabelStyle: textCorpsStyle.copyWith(color: teal),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: espaceLg,
        vertical: espaceMd,
      ),
      border: OutlineInputBorder(
        borderRadius: rayonChampBordure,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: rayonChampBordure,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: rayonChampBordure,
        borderSide: const BorderSide(color: teal, width: 1.5),
      ),
    ),
    tabBarTheme: TabBarThemeData(
      dividerColor: bordureNeutre,
      indicatorColor: teal,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: teal, width: 2),
      ),
      labelColor: noir,
      unselectedLabelColor: texteSecondaire,
      labelStyle: textTitreStyle.copyWith(fontSize: 14),
      unselectedLabelStyle: textCorpsStyle,
    ),
    dividerTheme: const DividerThemeData(
      color: bordureNeutre,
      thickness: 1,
      space: espaceXl,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: teal,
      linearTrackColor: surfaceNeutre,
      circularTrackColor: surfaceNeutre,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: noir,
      contentTextStyle: textCorpsStyle.copyWith(color: blanc),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: rayonChampBordure),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: blanc,
      surfaceTintColor: blanc,
      scrimColor: noir.withValues(alpha: 0.55),
      elevation: 0,
    ),
  );
}
