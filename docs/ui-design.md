# Direction UI — noir, blanc, teal

## Recherche menée (novembre 2026)

| Référence | Ce qui marche et que l'on reprend |
|---|---|
| [Split: Would You Rather?](https://apps.apple.com/us/app/split-would-you-rather/id1446698289) (6 M de réponses) | « Tap the half you would rather have — the screen slides to the real split ». Décision en un geste, puis révélation immédiate de la répartition réelle. On reprend le **tap sur une option** en plus du swipe, et une **barre de répartition** sur l'écran résultat. |
| [Versus — Haveagoodtime](https://thms.works/work/versus) | Le constat explicite que les apps du genre sont « outdated and designed for a solo use » ; le social est au cœur. On donne donc au **total des votes** et au pourcentage une place centrale dans le résultat. |
| [Mobbin — formulaires de sondage](https://mobbin.com/explore/screens/300160ef-204d-4a55-a760-5447c023ed3c) (Nextdoor, Instagram, GroupMe, Reddit) | Une question, deux options nommées, une seule action de création. On simplifie les formulaires et on supprime les éléments morts/commentés. |
| [ui-ux-pro-max — Minimalism & Swiss Style](.opencode/skills/ui-ux-pro-max/) | Contraste élevé, blanc, grille, sans-serif, hiérarchie nette, cibles tactiles ≥ 48 dp. La palette proposée par l'outil (rose/bleu) est **rejetée** : elle contredit la contrainte des trois couleurs. |

Le swipe reste disponible, mais n'est plus le seul moyen de voter : un bouton
A/B sous la carte déclenche la même animation via `CardSwiperController`. Cela
répond aussi à l'exigence d'alternative au geste pour l'accessibilité.

## Tokens

Définis dans `lib/constants.dart`, appliqués dans `lib/theme.dart` :

- `noir` `#0A0A0A`, `blanc` `#FFFFFF`, `teal` `#0F766E` (contraste 5,5:1 avec blanc).
- Gris `#595959`, `#F3F5F5`, `#D8DEDE` : teintes de noir, pas des couleurs supplémentaires.
- Option A = noir, option B = teal, y compris dans les pourcentages et la barre de répartition.
- Espacements 4/8/12/16/24 ; rayons concentriques carte 24 / contenu 16 / champ 12.
- Une seule famille de police (Inter) remplace les deux polices précédentes.

## Identité visuelle : une seule marque

- Le `Logo` (`lib/widgets/logo.dart`) est la source de vérité : disque noir,
  couches blanches (`layer-group`) et point teal cerclé de blanc en haut à
  droite. Le point est **entièrement contenu** dans le diamètre du disque :
  plus de chevauchement ni de coin coupé dans l'app bar.
- Sur le feed, la marque est en haut à gauche, suivie du mot « avis » dans une
  barre de 72 dp (disque de 36 dp). Elle n'est plus centrée ni serrée dans une
  barre de 56 dp.
- Les icônes Android et web sont générées depuis cette même géométrie par
  `python3 tool/generate_app_icons.py` : mipmaps 48→192, `Icon-192/512`,
  variantes maskable (disque réduit à 60 % pour la zone sûre) et favicon.
  Aucune icône launcher par défaut n'est conservée.

## En-têtes, dates et formulaires

- La date d'un duel est formatée en `19 oct. 2026` (mois en toutes lettres),
  ou en `Aujourd'hui` / `Hier` / `il y a N jours` pour la semaine courante.
  Le tooltip donne la date et l'heure exactes (`formatDateComplete`).
- Le profil est une suite de surfaces lisibles : en-tête carte avec nom sur
  deux lignes maximum, statistiques avec icônes teal, puis un titre de section
  « Mes duels » avant la grille. Le titre de la barre reste « Mon profil » :
  le nom n'est plus lu deux fois.
- Les deux formulaires de création partagent `FormActionBarWidget` : bouton
  « Publier » ancré en bas, séparé par un trait, décalé de la navigation
  gestuelle par le `SafeArea` de `NewPostScreen` et toujours au-dessus du
  clavier pendant la saisie.

## Flux d'authentification : invité par défaut

- L'application démarre en **invité** : `AuthGate` affiche directement le feed
  dès que `AuthRepository.initialize()` a publié une session. Il n'y a plus
  d'écran de connexion au lancement.
- L'élévation se fait dans une **feuille modale** (`AuthenticationScreen`)
  au-dessus du feed, au premier acte d'écriture ou d'ouverture du formulaire :
  vote, publication, « + » de la barre basse. La page de profil est en lecture
  seule (hors déconnexion). Le feed reste monté derrière ; la feuille se ferme
  en cas de succès.
- `demanderElevation(context, action: ...)` est la porte unique : le vote n'est
  retiré du feed qu'après l'écriture confirmée (pas d'ajout optimiste dans
  `interactedDuals`) et les formulaires ne vident leurs champs qu'après une
  publication confirmée.
- Un seul formulaire : **pseudo** (3 à 20 lettres, chiffres ou tirets bas,
  `^[A-Za-z0-9_]{3,20}$`) puis **mot de passe** (8 caractères minimum).
  Ni email, ni nom/prénom, ni Google, ni « mot de passe oublié ».
- En échec, on reste invité : l'action d'écriture est annulée (jamais rejouée),
  les saisies restent dans la feuille, le message d'erreur est affiché sous les
  champs et le réessai est possible. Le flux d'authentification est l'unique
  source de vérité : plus de navigation ni de `ValueKey` de retry pour l'auth.
- « Déconnecter » est une `IconButton` dans le trailing de l'app bar du profil :
  l'action reste accessible sans défiler les duels, et l'app repasse en invité
  sans écran de connexion.

## Navigation et tour des duels

- La barre basse remplace le drawer : Feed à gauche, Profil à droite. Le rendu
  est un `CupertinoTabBar` dont les couleurs viennent de `lib/constants.dart`
  (fond blanc, actif teal, inactif gris, bordure neutre). Ses deux coins
  supérieurs sont arrondis au rayon des cartes (`rayonCarte`) et le trait est
  tracé sur la courbe. Le « + » teal est un `FloatingActionButton` docké au centre
  (`FloatingActionButtonLocation.centerDocked`) : c'est une action de création,
  pas un onglet, et elle passe par `demanderElevation`.
- Un unique `MainNavigationShell` porte le `Scaffold`, la barre et le FAB. Les
  deux onglets vivent dans un `IndexedStack` : sélectionner Feed ou Profil ne
  pousse aucune route et ne reconstruit pas l'autre page. Résultat, formulaire
  et authentification restent de vraies routes et n'héritent pas de la barre.
- La carte du feed et l'écran résultat partagent la même gouttière : 24 dp
  autour de la carte, 16 dp pour son contenu interne (en-tête, question, options,
  boutons de vote).`
- « Passer ce duel » est une ligne discrète sous les deux boutons de vote. C'est
  une action locale : aucun vote écrit, aucune élévation, aucun snackbar. Un
  invité peut passer.
- Le duel ignoré quitte le tour courant (`skippedIds`) puis revient dès que les
  autres duels ont été vus. Le retour est silencieux : ni message, ni compteur,
  ni état transitoire. Le libellé « Vous avez voté sur tous les duels » ne
  s'affiche que si la file est vide et qu'aucun duel n'a été ignoré.
- `AuthSessionStatus.failed` est un état explicite. S'il survient pendant
  l'initialisation (aucun identifiant d'invité), un message et un bouton
  « Réessayer » remplacent le feed ; s'il conserve un `authUserId`, l'erreur
  reste portée par la session et la feuille l'affiche sans masquer le feed.
- La feuille utilise les mêmes tokens (noir/blanc/teal, Inter, rayons et
  espacements de `lib/constants.dart`) et le thème de `lib/theme.dart`.

## Non-objectifs de l'itération design

- Aucun package UI ajouté : la barre utilise le `CupertinoTabBar` et le
  `FloatingActionButton` fournis par Flutter. Aucune modification des modèles,
  des services de données ni du contrat backend dans cette itération
  (la refonte backend est décrite dans
  [`docs/serverpod.md`](serverpod.md)). Les ajustements de la logique
  de vote restent côté vue : ils ne font que rendre explicite le succès déjà
  requis par la porte d'élévation.
- Les textes exacts utilisés par les tests non-auth (états d'erreur,
  'Réessayer', 'Nombre total de votes') et l'ordre des champs de formulaire
  sont conservés.
- `Responsiveness.maxWidth` reste à 600 pour ne pas casser les tests de layout.
