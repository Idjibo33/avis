# AGENTS.md — avis

## Git

- `main` = production, `develop` = développement. Le travail quotidien (features, correctifs, refactoring) cible `develop` ; une mise en production se fait par fusion de `develop` dans `main`, idéalement via PR.
- La CI (`.github/workflows/flutter.yml`) s'exécute sur `push` et `pull_request` vers `main` **et** `develop`.
- Ne jamais committer `.opencode/`, `PROMPT_INITIAL.md`, ni la réécriture de `pubspec.lock` produite par Flutter 3.50.

## Vérifications

- Ordre CI (`.github/workflows/flutter.yml`) : `flutter pub get` → `flutter analyze --no-fatal-infos` (racine, `serverpod/**` exclu) + `dart pub get` / `dart analyze` dans `serverpod/` → `flutter test` → `flutter build web --release`.
- Test ciblé : `flutter test test/helpers/validation_test.dart` ; un cas précis : `flutter test --plain-name "nom du test"`.
- `flutter test` passe localement (72 tests / 22 fichiers), sans service externe.
- Avec le Flutter 3.50 installé ici, `dart analyze lib test` remonte 63 infos `deprecated_member_use` (`package:flutter/material.dart` → `package:material_ui/material_ui.dart`) mais **sort en code 0** ; `flutter analyze` remonte les mêmes infos et **sort en code 1** : dérive de toolchain, pas une régression à corriger en urgence. Le workspace `serverpod/` a été renommé `avis_workspace` pour ne plus ajouter d'info `package_names`. Le CI utilise `channel: stable` sans version épinglée.
- `flutter pub get` (y compris la résolution implicite déclenchée par `flutter test`) avec ce SDK réécrit `pubspec.lock` : ne pas committer ce changement sauf demande explicite.

## Configuration et secrets

- `.env` (gitignored, à copier depuis `.env.example`) définit `SERVERPOD_URL`, lu par `String.fromEnvironment` dans `lib/main.dart` ; défaut `http://localhost:8080`.
- Dev : `flutter run --dart-define-from-file=.env` ; web : `flutter build web --dart-define=SERVERPOD_URL=...`. Le CI ne fournit aucun define : le client vise localhost.
- Le serveur lit `serverpod/avis_server/config/passwords.yaml`, copié depuis `passwords.yaml.example` (gitignoré) : ne jamais committer de vraies valeurs.
- Endpoints, modèles `*.spy.yaml` et migrations sont désormais versionnés dans `serverpod/avis_server/` (`lib/src/`, `migrations/`) ; après édition, `serverpod generate` puis `serverpod create-migration` depuis `serverpod/avis_server/`. Supabase a été retiré du code et des dépendances.

## Câblage

- `main.dart` crée le dépôt d'auth via `createAuthRepository` (client `serverpod/avis_client/`) puis expose 4 `ChangeNotifier` via `MultiProvider` ; `AuthGate` arbitre entre chargement, feed et erreur selon `AuthSessionState`, et fournit `AuthElevationController`.
- `lib/Services/serverpod/` contient les adaptateurs (`auth_repository_factory`, `serverpod_auth_repository`, `posts_table_services`, `interactions_services`, `profile_table_services`, `storage_services`) : tous prennent un `Client` injectable, s'en servir hors de l'app.
- `lib/Helpers/navigators.dart` → `demanderElevation(context, action: ...)` est l'unique porte des écritures : invité → feuille puis action rejouée une seule fois après succès ; échec → action annulée et saisies conservées ; authentifié → exécution directe. Vote, publication et navigation vers le formulaire passent par cette porte.
- Casse des dossiers significative : `Models/`, `Services/`, `Providers/`, `Screens/`, `Helpers/` en majuscule, `widgets/` en minuscule. Les imports `package:avis/...` sont sensibles à la casse sur Linux ; `lib/Providers/post_table_proider.dart` est le nom réel (faute incluse).
- `lib/Helpers/platform_image.dart` ré-exporte conditionnellement l'implémentation io ou web (`dart.library.js_interop`) : vérifier les deux fichiers.

## Tests

- Fakes centralisés dans `test/fixtures/fakes.dart` ; les passer aux constructeurs de providers (`postsTableServices:`, `interactions:`, `authServices:`, ...).
- `FakePostsTableServices` pilote le stream avec `emit` / `emitError` / `close` ; enregistrer `addTearDown(posts.close)`.
- Dans tout test widget utilisant GoogleFonts, poser `GoogleFonts.config.allowRuntimeFetching = false` dans `setUpAll` pour éviter un fetch réseau.
- Un test d'écriture (`FeedScreen`, formulaires de post) doit fournir `AuthServicesProviders` et `AuthElevationController` en plus des providers de données : `demanderElevation` les lit dans le contexte.

## État

- Avant d'ajouter un booléen d'état, un `ValueKey` de retry ou un `FutureBuilder` dans un écran, consulter `docs/state-machines.md` : inventaire des états implicites, décision d'explicitation et ordre de migration.

## Conventions et dette connue

- Projet, UI et commits en français (Conventional Commits, voir `git log`).
- `PROMPT_INITIAL.md` et `.opencode/` sont non versionnés : le premier est un brief de session d'audit, pas une spec durable.
- Sept méthodes lèvent `UnimplementedError` dans les adaptateurs `lib/Services/serverpod/` (update d'un duel, delete/update d'un vote, delete/read/update d'une image, delete d'un profil) : ces parcours ne sont pas exposés par le backend.
- `.env.example` ne contient que `SERVERPOD_URL` : les anciennes clés Supabase `URL`/`ANONKEY` ont été retirées.
