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
| Feed | `lib/Screens/feed_screen.dart`, `lib/State/feed_view_state.dart` | `FeedStatus` : `loading / ready / empty / allVoted / failed` ; ensembles locaux `votedIds` / `skippedIds` |
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
   depuis le « + » de la barre basse. L'action reste différée jusqu'à une
   élévation réussie, ce qui solde S7 et S10.

Conséquence : S4, S5, S6, S7, S8, S10 et S11 sont soldées.

### Suite UX — 21/11/2026

Le mapleur du feed distingue désormais `empty` (aucun duel publié) de
`allVoted` (le flux contenait des duels mais ils ont tous été votés localement) :
les deux états ont un message différent dans `EmptyListCardWidget`. Le vote
ajoute aussi un `Set<int>` local de votes en cours, documenté comme extension de
S10 : il désactive A et B pendant l'écriture afin d'empêcher un double vote, sans
introduire de booléen d'écran. Le résultat reste consultable après un vote via
l'action « Voir le résultat » du SnackBar de confirmation.

### Suite navigation — 21/11/2026

Le drawer est remplacé par un shell de navigation unique : `CupertinoTabBar`
(Feed, Profil) et `FloatingActionButton` « + » central, portés une seule fois par
`MainNavigationShell`. Les onglets sont un `IndexedStack` : aucun `Navigator.push`
pour changer de page. La déconnexion passe dans le trailing de l'app bar du
profil. Le CTA `Créer un duel` est masqué dans l'état `allVoted` du feed pour
éviter la redondance avec le « + ».

Le tour de duels ajoute un second ensemble local, `skippedIds`, distinct de
`votedIds`. Passer un duel ne touche ni le backend ni l'élévation : l'identifiant
entre dans `skippedIds` et le mappeur le retire des visibles. Quand il ne reste
rien d'autre, le mappeur réintègre les ignorés non votés avant de considérer
l'état `allVoted` : aucun état vide transitoire, aucun message, aucun compteur.
`_cycle` n'est qu'une génération de `ValueKey` : il force le `CardSwiper` à
repartir de la première carte quand la liste visible est identique avant et
après un ignoré (cas du dernier duel).

### Suite profil — 22/11/2026

La liste des duels du profil sort du `StreamBuilder` implicite (S29) :
`ProfilePostsViewState` mappe vers `chargement / pret / vide / invite / echec`.
Une erreur affiche désormais un message et « Réessayer », plus un spinner sans
fin. Le `userId!` est supprimé des deux widgets du profil (S26) : un invité voit
un état `invite` lisible, sans crash ni flux nul.

Deux correctifs de câblage rendent cet état observable sur device :

1. `PostsTableServices` met en cache le dernier feed reçu et le rejoue à chaque
   lecteur. Un flux broadcast ne rejoue pas son historique **et son `onListen`
   ne s'appelle que pour le premier abonné** : publier le cache dans le
   `onListen` du contrôleur ne suffit pas quand le feed est déjà ouvert. Chaque
   appel à `readData()` crée donc son propre flux broadcast, alimenté par le
   contrôleur et qui émet le cache dès qu'on l'écoute. Une erreur vide le cache
   pour que le réessai relance la requête. `test/services/posts_table_services_test.dart`
   verrouille ce comportement.
2. `PostTableProider.readUserPost` mémorise le flux par utilisateur : son
   identité reste stable d'une image à l'autre, donc le `StreamBuilder` ne se
   désabonne et ne se réabonne pas en boucle.

### Suite vote — 23/11/2026

L'auteur d'un duel ne vote pas sur sa propre création. La règle est portée par
`motifRefusVote()` dans `UserEndpoint.vote` : le serveur compare `duel.authorId`
à l'identité de la session et refuse l'écriture. Côté client, `FeedScreen`
dérive `estAuteur` de `post.user` et de la session écoutée avec `watch` (pas
`read` : la session peut arriver après le premier build). Les cibles A/B sont
désactivées avec un message explicite ; « Passer ce duel » reste disponible.
Le swipe est bloqué par la même garde avant toute élévation ou écriture.
Aucun état booléen ajouté : `estAuteur` est une valeur dérivée, transmise de
`FeedScreen` à `CardWidget` puis `VoteDescriptionWidget`.

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
| S26 | `widgets/user_statistics_widget.dart`, `user_post_list_widget.dart` | `currentUser!` en parallèle du flux auth | H | Fait — `userId` nullable, état `invite` explicite |
| S27 | `widgets/user_statistics_widget.dart` | `StreamBuilder` posts, erreur = 0 | M | P1 |
| S28 | `widgets/user_statistics_widget.dart` | `FutureBuilder` votes, erreur = 0 | M | P1 |
| S29 | `widgets/user_post_list_widget.dart` | count 0 / grille / chargement, erreur = spinner infini, injection court-circuitée | H | Fait — `ProfilePostsViewState` + cache de flux + réessai |
| S30 | `widgets/drawer_widget.dart`, `feed_screen.dart` | drawer ouvert/fermé non fermé avant navigation | B | Fait — drawer supprimé, navigation directe depuis la barre basse |
| S31 | `Helpers/snackbar.dart` | `messengerKey` global, muet hors `MainApp`, sans dédup | M | P1 |
| S32 | `Providers/profile_table_provider.dart` | `_chargement` (bug `updateRow`) + `_messageErreur` | M | P1 |
| S33 | `Helpers/responsiveness.dart` | 2 paliers de largeur | B | P2 |
| S34 | `widgets/texte_field_widget.dart`, boutons | `obscureText` / `chargement` dérivés | B | P2 |
| S35 | `Screens/feed_screen.dart`, `State/feed_view_state.dart` | `skippedIds` (tour courant) et `_cycle` (génération de `ValueKey`) | M | Fait — ignorés réintégrés silencieusement quand la file est vide, sans état ni message ajouté |

## Ordre de migration

1. **P0 — perte de données / blocage** : S12, S16 (S10, S26 et S29 soldées). Règle : aucune avancée d'état local avant la confirmation de l'écriture, et une seule source pour l'utilisateur courant.
2. **P1 — information erronée** : S15, S17, S18, S19, S21, S25, S27, S28, S31, S32 (S7 soldée). Règle : mapper vers `OperationState` ou un état de vue, jamais de valeur par défaut sur `hasError`.
3. **P2 — confort** : S13, S14, S20, S23, S24, S30, S33, S34 (S30 soldée, S35 documentée). Règle : garder le comportement, rendre l'état nommé.

Critère d'acceptation pour chaque migration : un test de l'état nominal, un test d'erreur, un test de transition concurrente quand l'action est asynchrone, et `flutter test` vert.
