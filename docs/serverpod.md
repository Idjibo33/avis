# Backend Serverpod 4.1.2

Ce backend remplace l'ancien backend Supabase, désormais retiré du dépôt.

Backend généré avec le CLI officiel `serverpod_cli 4.1.2`, sans email, sans
vérification et sans récupération de mot de passe. Deux modes d'authentification
cohabitent :

1. **anonyme native** (`AnonymousIdpConfig` + `AnonymousIdpEndpoint`) ;
2. **pseudo + mot de passe applicatif** (`UsernameAuthEndpoint`), qui élève le
   compte anonyme **en conservant le même UUID** (pas de fusion de comptes, pas
   d'`accountMerger`, pas de provider `IdentityProvider` custom).

## Arborescence créée

```
serverpod/
├── pubspec.yaml                 # racine du workspace Dart (générée)
├── pubspec.lock                 # lock du workspace (généré)
├── .gitignore, .vscode/         # fichiers de support générés
├── avis_server/                 # serveur Dart
│   ├── bin/main.dart
│   ├── lib/server.dart          # initializeAuthServices(...)
│   ├── lib/src/auth/
│   │   ├── anonymous_idp_endpoint.dart
│   │   ├── jwt_refresh_endpoint.dart
│   │   ├── logged_in_endpoint.dart     # base locale (voir écarts)
│   │   └── username_auth_endpoint.dart
│   ├── lib/src/endpoints/
│   │   ├── public_feed_endpoint.dart   # lecture publique
│   │   └── user_endpoint.dart          # écritures authentifiées
│   ├── lib/src/models/
│   │   ├── username_account.spy.yaml
│   │   ├── duel.spy.yaml
│   │   └── vote.spy.yaml
│   ├── lib/src/generated/        # généré par `serverpod generate`
│   ├── config/passwords.yaml.example  # valeurs factices uniquement
│   ├── config/{development,staging,production,test}.yaml
│   └── migrations/               # 2 migrations générées par le CLI
└── avis_client/                 # paquet client généré
    ├── lib/avis_client.dart
    └── lib/src/protocol/{client.dart,protocol.dart,duel.dart,vote.dart}
```

Le `pubspec.yaml` racine de l'app Flutter a reçu **uniquement** ces ajouts :

```yaml
  avis_client:
    path: serverpod/avis_client
  serverpod_client: ^4.1.2
  serverpod_flutter: ^4.1.2
  serverpod_auth_idp_flutter: ^4.1.2
```

`supabase_flutter` a été retiré de `pubspec.yaml` : Supabase n'est plus une
dépendance de l'application.

## Packages et imports générés

| Côté | Package | Imports utiles |
| --- | --- | --- |
| Serveur | `avis_server` | `package:serverpod/serverpod.dart`, `package:serverpod_auth_idp_server/core.dart`, `package:serverpod_auth_idp_server/providers/anonymous.dart`, `package:serverpod_cloud_storage/serverpod_cloud_storage.dart` |
| Client | `avis_client` | `package:avis_client/avis_client.dart` (ré-exporte `package:serverpod_client/serverpod_client.dart`, `client.dart`, `duel.dart`, `vote.dart`) |
| Flutter | dépendances racine | `package:avis_client/avis_client.dart`, `package:serverpod_flutter/serverpod_flutter.dart`, `package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart` |

`Client` est généré dans `avis_client/lib/src/protocol/client.dart` et ré-exporté
par `avis_client.dart`. Signature exacte du constructeur généré :

```dart
Client(
  String host, {
  dynamic securityContext,
  Duration? streamingConnectionTimeout,
  Duration? connectionTimeout,
  Function(MethodCallContext, Object, StackTrace)? onFailedCall,
  Function(MethodCallContext)? onSucceededCall,
  bool? disconnectStreamsOnLostInternetConnection,
  http.Client? httpClientOverride,
})
```

Initialisation côté Flutter (vérifiée par `dart analyze` dans un projet témoin) :

```dart
import 'package:avis_client/avis_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

final client = Client('http://localhost:8080/')
  ..authSessionManager = FlutterAuthSessionManager();
await client.auth.initialize();
```

`FlutterAuthSessionManager` est exporté par `serverpod_auth_idp_flutter`
(ré-export de `serverpod_auth_core_flutter`). `client.auth.initialize()` renvoie
`Future<bool>`.

### Parcours d'authentification

```dart
// 1. Connexion anonyme : UUID créé par le serveur.
final guest = await client.anonymousIdp.login();
await client.auth.updateSignedInUser(guest);

// 2. Élévation : le pseudo est attaché au MÊME authUserId.
final elevated = await client.usernameAuth.register(pseudo, password);
await client.auth.updateSignedInUser(elevated);

// 3. Connexion suivante (aucune session requise).
final signedIn = await client.usernameAuth.signIn(pseudo, password);
await client.auth.updateSignedInUser(signedIn);
```

`register` révoque les jetons `method: 'anonymous'` de cet UUID puis émet un
jeton `method: 'username'` pour le même UUID via
`AuthServices.instance.tokenManager.issueToken`.

## Côté Flutter

`lib/Services/serverpod/` contient les adaptateurs du client généré :
`auth_repository_factory` et `serverpod_auth_repository` (session `AuthRepository`),
`posts_table_services` (duels du feed), `interactions_services` (votes),
`profile_table_services` (pseudo) et `storage_services` (upload d'images). Chacun
reçoit un `Client` injectable, ce qui permet de les remplacer par des fakes dans
les tests ; `lib/main.dart` les injecte dans les quatre providers.

Toutes les écritures existantes (vote, publication de duel, ouverture du
formulaire de post) passent par `demanderElevation(context, action: ...)` dans
`lib/Helpers/navigators.dart` : un invité voit la feuille, l'action est rejouée
une seule fois après succès et annulée en cas d'échec (saisies conservées) ; un
utilisateur authentifié exécute l'action directement. Toute future écriture de
profil doit emprunter la même porte.

## Signatures exactes (côté serveur)

```dart
// lib/src/auth/username_auth_endpoint.dart
class UsernameAuthEndpoint extends Endpoint {
  Future<AuthSuccess> register(Session session, String pseudo, String password) async;

  @unauthenticatedClientCall
  Future<AuthSuccess> signIn(Session session, String pseudo, String password) async;
}

// lib/src/endpoints/public_feed_endpoint.dart  (aucun requireLogin)
class PublicFeedEndpoint extends Endpoint {
  Future<List<Duel>> listDuels(Session session, {int limit = 50}) async;
  Future<List<Vote>> listVotes(Session session, int duelId) async;
  Future<int> countVotes(Session session, int duelId) async;
  Future<String?> authorName(Session session, UuidValue authUserId) async;
}

// lib/src/endpoints/user_endpoint.dart  (requireLogin => true)
class UserEndpoint extends LoggedInEndpoint {
  Future<Duel> createDuel(Session session, String question, String type,
      String? optionAText, String? optionAUrl,
      String? optionBText, String? optionBUrl) async;
  Future<Vote> vote(Session session, int duelId, String choix) async;
  Future<String> updateProfile(Session session, String pseudo) async;
  Future<Uri> uploadImage(Session session, ByteData bytes, String fileName) async;
  Future<bool> deleteDuel(Session session, int duelId) async;
}
```

Côté client généré (`client.usernameAuth`, `client.publicFeed`, `client.user`) :

```dart
Future<AuthSuccess> register(String pseudo, String password);
Future<AuthSuccess> signIn(String pseudo, String password); // authenticated: false
Future<List<Duel>> listDuels({required int limit});
Future<List<Vote>> listVotes(int duelId);
Future<int> countVotes(int duelId);
Future<String?> authorName(UuidValue authUserId);
Future<Duel> createDuel(String question, String type, String? optionAText,
    String? optionAUrl, String? optionBText, String? optionBUrl);
Future<Vote> vote(int duelId, String choix);
Future<String> updateProfile(String pseudo);
Future<Uri> uploadImage(ByteData bytes, String fileName);
Future<bool> deleteDuel(int duelId);
```

Attention : la valeur par défaut de `limit` n'est pas propagée au client ;
appeler `client.publicFeed.listDuels(limit: 50)`.

Toutes les écritures dérivent l'identité de `session.authenticated!.authUserId` :
aucun `userId` n'est accepté en paramètre et aucune écriture n'est annotée
`@unauthenticatedClientCall`. Les lectures sont dans un endpoint séparé.

## Configuration des secrets

1. `cp serverpod/avis_server/config/passwords.yaml.example serverpod/avis_server/config/passwords.yaml`
2. Remplacer **toutes** les valeurs `REPLACE_WITH_...` (pepper Argon2
   `usernamePasswordHashPepper`, clé JWT `jwtHmacSha512PrivateKey`, pepper de
   refresh `jwtRefreshTokenHashPepper`, mots de passe DB/Redis/service).
3. `config/passwords.yaml` est gitignoré par le template ; ne jamais committer
   de vraies valeurs. Le fichier `.example` ne contient que des placeholders.

`lib/server.dart` appelle :

```dart
pod.initializeAuthServices(
  tokenManagerBuilders: [JwtConfigFromPasswords()],
  identityProviderBuilders: [AnonymousIdpConfig()],
);
```

## Modèles et migrations

- `UsernameAccount` (serverOnly, table `username_account`) : `authUserId`
  `UuidValue`, `username`, `usernameNormalized` (index **unique**),
  `passwordHash` (PHC Argon2id), `createdAt`. Un second index unique sur
  `authUserId` garantit un seul compte pseudo par UUID.
- `Duel` (table `duel`) : `authorId` (`UuidValue`), `authorName`, `question`,
  `type`, `optionAText/Url`, `optionBText/Url`, `createdAt`.
- `Vote` (table `vote`) : `duelId`, `userId`, `choix`, `createdAt`, index unique
  `(duelId, userId)` (un vote par utilisateur et par duel).
- Migrations générées : `20261119094359002` (initiale du template) puis
  `20261119095720791` (tables applicatives + delta du template). Elles sont
  l'œuvre de `serverpod create-migration`, pas écrites à la main.

## Commandes

Réussies :

```bash
dart pub global activate serverpod_cli --version 4.1.2
export PATH="$PATH:$HOME/.pub-cache/bin"
serverpod --version                       # Serverpod version: 4.1.2
cd serverpod && dart pub get
cd avis_server && serverpod generate
cd avis_server && serverpod create-migration
cd serverpod && dart analyze              # 1 info: nom de package '_' (workspace CLI)
cd serverpod && dart format .
cd serverpod/avis_server && dart test      # aucun test présent
```

Vérification hors dépôt (sans toucher au `pubspec.lock` racine) : un projet
Dart témoin dans `/tmp/opencode/avis_pub_test` avec les 4 dépendances ajoutées
au `pubspec.yaml` racine, un `import 'package:avis_client/avis_client.dart'` et
le snippet d'initialisation : `dart pub get` + `dart analyze` → **No issues
found**. Le `pubspec.lock` racine n'a **pas** été régénéré.

Échecs / corrections en cours de route :

- `serverpod create avis --template server --auth --database --no-webapp
  --no-website --ide none` a d'abord été lancé depuis la racine du dépôt et a
  créé `avis/` à côté de `serverpod/` ; les fichiers utiles ont été déplacés
  dans `serverpod/` et le dossier stray supprimé.
- Le premier `serverpod generate` a échoué : `defaultPersist=increment` n'est
  pas valide dans Serverpod 4.1.2 (`serial` attendu) et les classes générées
  n'existaient pas encore. Corrigé, puis `generate` → ✅.
- `serverpod generate` avant `dart pub get` dans le workspace →
  `Failed to locate module dependency path ... for dependency: serverpod`.
  Corrigé par `cd serverpod && dart pub get`.

## Écarts / points non générés

- **Aucun `LoggedInEndpoint` n'existe dans Serverpod 4.1.2.** Une classe locale
  `abstract class LoggedInEndpoint extends Endpoint` avec
  `bool get requireLogin => true` a donc été créée dans
  `serverpod/avis_server/lib/src/auth/logged_in_endpoint.dart` ; `UserEndpoint`
  en hérite comme demandé. Le générateur produit un `abstract EndpointLoggedIn`
  côté client (sans méthode).
- Le provider email du template a été retiré de `lib/server.dart` et son endpoint
  supprimé. Les tables des modules auth (y compris email) restent présentes dans
  les migrations générées par Serverpod : ce sont des tables de module, aucun
  endpoint email n'est exposé.
- Aucun import de données Supabase, aucun test serveur et aucun déploiement :
  hors périmètre. Le fichier `config/passwords.yaml` réel doit être créé côté
  serveur avant le premier lancement (le template en génère un avec des valeurs
  aléatoires, mais il est gitignoré).
- Les erreurs métier sont des `FormatException` avec message générique ; le
  client reçoit une erreur serveur sérialisée. Aucun code d'erreur typé n'a été
  ajouté (pas de `.spy.yaml` d'exception).
- `PublicFeedEndpoint.authorName` lit `UsernameAccount` (serverOnly) et ne
  renvoie qu'une `String?` : aucun modèle serverOnly n'est exposé au client.
