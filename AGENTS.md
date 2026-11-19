# AGENTS.md — avis

## Git

- `main` = production, `develop` = développement. Le travail quotidien (features, correctifs, refactoring) cible `develop` ; une mise en production se fait par fusion de `develop` dans `main`, idéalement via PR.
- La CI (`.github/workflows/flutter.yml`) s'exécute sur `push` et `pull_request` vers `main` **et** `develop`.
- Ne jamais committer `.opencode/`, `PROMPT_INITIAL.md`, ni la réécriture de `pubspec.lock` produite par Flutter 3.50.

## Vérifications

- Ordre CI (`.github/workflows/flutter.yml`) : `flutter pub get` → `flutter analyze` → `flutter test` → `flutter build web --release`.
- Test ciblé : `flutter test test/helpers/validation_test.dart` ; un cas précis : `flutter test --plain-name "nom du test"`.
- `flutter test` passe localement (51 tests / 21 fichiers), sans service externe.
- Avec le Flutter 3.50 installé ici, `flutter analyze` remonte 65 infos `deprecated_member_use` (`package:flutter/material.dart` → `package:material_ui/material_ui.dart`) et **sort en code 1** : dérive de toolchain, pas une régression à corriger en urgence. Le CI utilise `channel: stable` sans version épinglée.
- `flutter pub get` avec ce SDK réécrit `pubspec.lock` (clock, listen, stack_trace, test_api) : ne pas committer ce changement sauf demande explicite.

## Configuration et secrets

- `.env` (gitignored, à copier depuis `.env.example`) définit `URL` et `ANONKEY`, lus par `String.fromEnvironment` dans `lib/main.dart`.
- Dev : `flutter run --dart-define-from-file=.env` ; web : `flutter build web --dart-define=URL=... --dart-define=ANONKEY=...`. Sans defines, l'app compile mais ne joint pas Supabase. Le CI ne fournit aucun define.
- Schéma Postgres, RLS et règles Storage vivent dans le dashboard Supabase, hors dépôt : une correction backend ne se fait pas ici.

## Câblage

- `main.dart` initialise Supabase puis expose 4 `ChangeNotifier` via `MultiProvider` ; `AuthGate` arbitre entre `AuthenticationScreen` et `FeedScreen` selon le flux `authState`.
- Casse des dossiers significative : `Models/`, `Services/`, `Providers/`, `Screens/`, `Helpers/` en majuscule, `widgets/` en minuscule. Les imports `package:avis/...` sont sensibles à la casse sur Linux ; `lib/Providers/post_table_proider.dart` est le nom réel (faute incluse).
- Les services Supabase créent `Supabase.instance.client` comme champ d'instance : les construire exige `Supabase.initialize`. Les providers acceptent des services injectables — s'en servir hors de l'app.
- `lib/Helpers/platform_image.dart` ré-exporte conditionnellement l'implémentation io ou web (`dart.library.js_interop`) : vérifier les deux fichiers.

## Tests

- Fakes centralisés dans `test/fixtures/fakes.dart` ; les passer aux constructeurs de providers (`postsTableServices:`, `interactions:`, `authServices:`, ...).
- `FakePostsTableServices` pilote le stream avec `emit` / `emitError` / `close` ; enregistrer `addTearDown(posts.close)`.
- Dans tout test widget utilisant GoogleFonts, poser `GoogleFonts.config.allowRuntimeFetching = false` dans `setUpAll` pour éviter un fetch réseau.

## État

- Avant d'ajouter un booléen d'état, un `ValueKey` de retry ou un `FutureBuilder` dans un écran, consulter `docs/state-machines.md` : inventaire des états implicites, décision d'explicitation et ordre de migration.

## Conventions et dette connue

- Projet, UI et commits en français (Conventional Commits, voir `git log`).
- `PROMPT_INITIAL.md` et `.opencode/` sont non versionnés : le premier est un brief de session d'audit, pas une spec durable.
- Six méthodes `TODO` lèvent `UnimplementedError` dans `lib/Services/Supabase/` (Google sign-in, delete/update des interactions, delete/read/update du storage) : ces parcours ne sont pas fonctionnels.
