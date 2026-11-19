# États implicites → états explicites

Audit du 19/11/2026. Avant ce changement : **34 machines à états implicites** dans `lib/`, **aucun** `enum`, `sealed class` ou type d'état explicite. Le comportement était inféré de booléens, de chaînes, de `FutureBuilder`/`StreamBuilder`, de `ValueKey` et de la navigation.

## Décision

Un seul état typé par flux, possédé par le producteur de l'état (provider ou mapper pur) et consommé par une vue exhaustive. Aucune machine supplémentaire introduite sous forme de booléen, de message libre ou de clé de widget.

- `OperationState` (`lib/State/operation_state.dart`) : `idle / running / succeeded / failed`, avec `when` exhaustif. Un seul appel en cours, tout échec est un état terminal, le message d'erreur est effacé au succès.
- `AuthGateViewState` et `FeedViewState` : mappers purs (`AuthSessionState` / `AsyncSnapshot`) vers un `enum` d'état. La vue ne fait que `switch`, sans brancher des valeurs par défaut sur des erreurs.
- Les getters historiques (`chargement`, `messageErreur`) restent exposés : migration additive, aucun appelant cassé, aucun nouveau package.

Ce choix sert les trois publics en même temps :

| Public | Gain |
|---|---|
| UX | Chargement, vide, erreur et succès sont des états distincts ; plus de bouton bloqué, de message périmé ni d'erreur affichée comme un `0`. |
| DX | Une seule source de vérité par flux, des transitions au même endroit, des getters de compatibilité : les écrans existants continuent de fonctionner. |
| AX | Les états et transitions sont nommés, `grep`-ables et testés sans backend ; ajouter un flux revient à suivre le même patron. |

Non-objectifs de l'audit initial : pas de changement de design, pas de réécriture des 34 machines d'un coup, pas d'ajout de dépendance. Suite à la refonte du 19/11/2026, le contrat backend n'est plus un non-objectif : l'authentification passe par `AuthRepository` puis par le backend Serverpod, et Supabase a été retiré du dépôt.

## Déjà explicite (cette itération)

| Flux | Fichiers | Nouvel état |
|---|---|---|
| Opérations auth | `lib/Providers/auth_services_providers.dart` | `OperationState` + garde anti-double-appel |
| Session | `lib/Services/auth_repository.dart` | `AuthSessionStatus` : `unknown / guest / authenticated / failed` |
| Garde d'auth | `lib/auth_gate.dart`, `lib/State/auth_gate_state.dart` | `AuthGateStatus` : `loading / guest / authenticated / failed` (retry) |
| Élévation | `lib/State/auth_gate_state.dart` | `AuthElevationController` : action différée, rejouée une seule fois après succès |
| Feed | `lib/Screens/feed_screen.dart`, `lib/State/feed_view_state.dart` | `FeedStatus` : `loading / ready / empty / failed` |
| Total des votes | `lib/widgets/duel_resultat_total.dart` | `data / erreur / indisponible / chargement` distincts ; le provider avale les erreurs et renvoie `null`, donc un `done` sans donnée affiche « Indisponible » au lieu d'un `0` mensonger ; plus de crash sur `null` |

### Suite auth — 19/11/2026

Le flux d'authentification a été réécrit autour de `AuthRepository` et de `AuthSessionStatus` :

1. `unknown` affiche uniquement le spinner ; `guest` **et** `authenticated` affichent directement le feed.
2. Un `failed` qui conserve un `authUserId` est ramené à `guest` : l'erreur est portée par la feuille d'élévation, pas par un écran bloquant.
3. L'élévation est une action différée : `AuthElevationController.demander()` mémorise l'écriture, `reprendre()` la rejoue une seule fois après succès, `annuler()` la supprime après échec.
4. Les saisies de la feuille ne sont jamais effacées sur échec, et le dépôt reste invité.
5. `signOut()` republie `guest` : le feed reste visible, aucune navigation manuelle.
6. Les écritures passent par `demanderElevation(context, action: ...)` : vote
   (`FeedScreen`), publication (deux formulaires) et ouverture du formulaire
   depuis le drawer. L'action reste différée jusqu'à une élévation réussie, ce
   qui solde S7 et S10.

Conséquence : S4, S5, S6, S7, S8, S10 et S11 sont soldées.

## Inventaire complet

`Risque` : **H** = perte de données ou blocage, **M** = information erronée, **B** = confort.

| # | Où | État implicite | Risque | Migration |
|---|---|---|---|---|
| S1 | `lib/auth_gate.dart` | phases `StreamBuilder` + `session` ; erreur confondue avec déconnecté | H | Fait |
| S2 | `Providers/auth_services_providers.dart` | `_chargement` booléen | H | Fait |
| S3 | `Providers/auth_services_providers.dart` | `_messageErreur` jamais effacé | M | Fait |
| S4 | `Helpers/validation.dart` | validation connexion (bool) | M | Fait — `erreurValidationElevation()` (pseudo + mot de passe) |
| S5 | `Helpers/validation.dart` | validation inscription (4 branches) | M | Fait — formulaire d'inscription supprimé |
| S6 | `Screens/authentication_screen.dart` | index `TabController` | B | Fait — onglets supprimés, feuille unique |
| S7 | `widgets/connexion_widget.dart`, `texte_post_form_widget.dart`, `photos_post_form_widget.dart` | `TextEditingController` + effacement après `await` | H | Fait — action différée par `demanderElevation`, contrôleurs vidés seulement après succès |
| S8 | `Helpers/navigators.dart`, widgets d'auth | `Future<bool>` + `pushAndRemoveUntil` en double vérité du flux auth | H | Fait — `AuthRepository` est l'unique source |
| S9 | `Screens/feed_screen.dart` | phases `StreamBuilder` feed | M | Fait |
| S10 | `Screens/feed_screen.dart` | `interactedDuals` (votes locaux non persistés, erreurs avalées) | H | Fait — id ajouté seulement après `await` de l'écriture via `demanderElevation` |
| S11 | `auth_gate.dart` | `tentative` = génération d'abonnement | M | Fait — retry explicite via `initialize()` |
| S12 | `Screens/feed_screen.dart` | direction du swipe → choix A/B | H | P0 |
| S13 | `Screens/feed_screen.dart` | `numberOfCardsDisplayed` dérivé | B | P2 |
| S14 | `widgets/empty_list_card_widget.dart` | CTA de l'état vide | B | P2 |
| S15 | `widgets/post_reactions_widget.dart` | `FutureBuilder` compteur, erreur = 0, future recréé | M | P1 |
| S16 | `Models/post.dart` + services/widgets | `Post.type` en `String` (`text`/`image`/autre) | H | P0 |
| S17 | `Providers/post_table_proider.dart` | `_chargement` + `_message` + snackbars | H | P1 |
| S18 | `widgets/image_field_widget.dart` | `pickedImage` local désynchronisé du parent | M | P1 |
| S19 | `widgets/photos_post_form_widget.dart` | paire `XFile?` A/B + reset sur erreur | H | P1 |
| S20 | `Screens/new_post_screen.dart` | index `TabController` Photos/Idées, chargement partagé | M | P2 |
| S21 | `widgets/duel_resultat_pourcentage_widget.dart` | deux `FutureBuilder`, erreur = 0 % | M | P1 |
| S22 | `widgets/duel_resultat_total.dart` | `ConnectionState` + `hasError` + `data!` (crash) | H | Fait |
| S23 | `Screens/resultat_duel_screen.dart` | `post.id ?? 0` (sentinelle) | M | P2 |
| S24 | `widgets/mini_card_widget.dart` | navigation vers le résultat, hors helper | B | P2 |
| S25 | `Screens/user_profil_screen.dart` | deux `FutureBuilder` dupliqués, erreur = anonyme | M | P1 |
| S26 | `widgets/user_statistics_widget.dart`, `user_post_list_widget.dart` | `currentUser!` en parallèle du flux auth | H | P0 |
| S27 | `widgets/user_statistics_widget.dart` | `StreamBuilder` posts, erreur = 0 | M | P1 |
| S28 | `widgets/user_statistics_widget.dart` | `FutureBuilder` votes, erreur = 0 | M | P1 |
| S29 | `widgets/user_post_list_widget.dart` | count 0 / grille / chargement, erreur = spinner infini, injection court-circuitée | H | P0 |
| S30 | `widgets/drawer_widget.dart`, `feed_screen.dart` | drawer ouvert/fermé non fermé avant navigation | B | P2 |
| S31 | `Helpers/snackbar.dart` | `messengerKey` global, muet hors `MainApp`, sans dédup | M | P1 |
| S32 | `Providers/profile_table_provider.dart` | `_chargement` (bug `updateRow`) + `_messageErreur` | M | P1 |
| S33 | `Helpers/responsiveness.dart` | 2 paliers de largeur | B | P2 |
| S34 | `widgets/texte_field_widget.dart`, boutons | `obscureText` / `chargement` dérivés | B | P2 |

## Ordre de migration

1. **P0 — perte de données / blocage** : S12, S16, S26, S29 (S10 soldée). Règle : aucune avancée d'état local avant la confirmation de l'écriture, et une seule source pour l'utilisateur courant.
2. **P1 — information erronée** : S15, S17, S18, S19, S21, S25, S27, S28, S31, S32 (S7 soldée). Règle : mapper vers `OperationState` ou un état de vue, jamais de valeur par défaut sur `hasError`.
3. **P2 — confort** : S13, S14, S20, S23, S24, S30, S33, S34. Règle : garder le comportement, rendre l'état nommé.

Critère d'acceptation pour chaque migration : un test de l'état nominal, un test d'erreur, un test de transition concurrente quand l'action est asynchrone, et `flutter test` vert.
