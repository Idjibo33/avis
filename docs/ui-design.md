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

## Flux d'authentification : invité par défaut

- L'application démarre en **invité** : `AuthGate` affiche directement le feed
  dès que `AuthRepository.initialize()` a publié une session. Il n'y a plus
  d'écran de connexion au lancement.
- L'élévation se fait dans une **feuille modale** (`AuthenticationScreen`)
  au-dessus du feed, au premier acte d'écriture ou d'ouverture du formulaire :
  vote, publication, « Faire un post ». La page de profil est en lecture seule.
  Le feed reste monté derrière ; la feuille se ferme en cas de succès.
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
- « Déconnecter » dans le drawer repasse en invité sans quitter le feed.
- `AuthSessionStatus.failed` est un état explicite. S'il survient pendant
  l'initialisation (aucun identifiant d'invité), un message et un bouton
  « Réessayer » remplacent le feed ; s'il conserve un `authUserId`, l'erreur
  reste portée par la session et la feuille l'affiche sans masquer le feed.
- La feuille utilise les mêmes tokens (noir/blanc/teal, Inter, rayons et
  espacements de `lib/constants.dart`) et le thème de `lib/theme.dart`.

## Non-objectifs de l'itération design

- Aucun nouveau package, aucune modification des modèles, services de données
  ou de la logique de vote dans cette itération (la refonte backend est décrite
  dans [`docs/serverpod.md`](serverpod.md)).
- Les textes exacts utilisés par les tests non-auth (états d'erreur,
  'Réessayer', 'Nombre total de votes') et l'ordre des champs de formulaire
  sont conservés.
- `Responsiveness.maxWidth` reste à 600 pour ne pas casser les tests de layout.
