const List<String> _moisCourt = <String>[
  'janv.',
  'févr.',
  'mars',
  'avr.',
  'mai',
  'juin',
  'juil.',
  'août',
  'sept.',
  'oct.',
  'nov.',
  'déc.',
];

const List<String> _moisLong = <String>[
  'janvier',
  'février',
  'mars',
  'avril',
  'mai',
  'juin',
  'juillet',
  'août',
  'septembre',
  'octobre',
  'novembre',
  'décembre',
];

DateTime? _parse(Object? date) =>
    DateTime.tryParse(date?.toString() ?? '')?.toLocal();

/// Date absolue lisible : `19 oct. 2026` plutôt que `19/10/2026`.
///
/// Le mois en toutes lettres supprime l'ambiguïté jour/mois et occupe la même
/// largeur qu'une date numérique. Une valeur invalide est renvoyée telle quelle.
String formatDate(Object? date) {
  final DateTime? timestamp = _parse(date);
  if (timestamp == null) {
    return date?.toString() ?? '';
  }
  final String jour = timestamp.day.toString().padLeft(2, '0');
  return '$jour ${_moisCourt[timestamp.month - 1]} ${timestamp.year}';
}

/// Libellé court pour l'en-tête d'une carte : « Aujourd'hui », « Hier »,
/// « il y a 3 jours », puis la date absolue au-delà d'une semaine.
///
/// `maintenant` est injectable pour rendre le rendu déterministe en test.
String formatDateRelative(Object? date, {DateTime? maintenant}) {
  final DateTime? timestamp = _parse(date);
  if (timestamp == null) {
    return date?.toString() ?? '';
  }
  final DateTime aujourdHui = maintenant ?? DateTime.now();
  final int jours = DateTime(
    aujourdHui.year,
    aujourdHui.month,
    aujourdHui.day,
  ).difference(
    DateTime(timestamp.year, timestamp.month, timestamp.day),
  ).inDays;

  return switch (jours) {
    0 => "Aujourd'hui",
    1 => 'Hier',
    >= 2 && < 7 => 'il y a $jours jours',
    _ => formatDate(date),
  };
}

/// Date complète destinée au tooltip / aux lecteurs d'écran.
String formatDateComplete(Object? date) {
  final DateTime? timestamp = _parse(date);
  if (timestamp == null) {
    return date?.toString() ?? '';
  }
  final String heure = timestamp.hour.toString().padLeft(2, '0');
  final String minute = timestamp.minute.toString().padLeft(2, '0');
  return '${timestamp.day} ${_moisLong[timestamp.month - 1]} ${timestamp.year}'
      ' à $heure:$minute';
}
