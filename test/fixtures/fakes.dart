import 'dart:async';

import 'package:avis/Models/interaction.dart';
import 'package:avis/Models/post.dart';
import 'package:avis/Models/profile.dart';
import 'package:avis/Services/auth_repository.dart';
import 'package:avis/Services/serverpod/interactions_services.dart';
import 'package:avis/Services/serverpod/posts_table_services.dart';
import 'package:avis/Services/serverpod/profile_table_services.dart';
import 'package:avis/Services/serverpod/storage_services.dart';
import 'package:image_picker/image_picker.dart';

class FakeProfileTableServices implements ProfileTableServices {
  @override
  String get table => 'profiles';

  @override
  Future addData(Profile item) async {}

  @override
  Future deletedata(Profile item) async {}

  @override
  Stream<List<Profile>> readData() => const Stream<List<Profile>>.empty();

  @override
  Future<Profile> readDataOnce(String id) async =>
      Profile(nom: 'Adamou', prenom: 'Ismaël', email: 'a@b.c');

  @override
  Future updateData(Profile item) async {}
}

class FakePostsTableServices implements PostsTableServices {
  final StreamController<List<Post>> controller =
      StreamController<List<Post>>.broadcast();
  final List<Post> added = [];

  @override
  String get table => 'posts';

  @override
  Future addData(Post item) async {
    added.add(item);
  }

  @override
  Future deletedata(Post item) async {}

  @override
  Future updateData(Post item) async {}

  @override
  Stream<List<Post>> readData() => controller.stream;

  @override
  Stream<PostWithCount> getUserPosts(String userId) =>
      Stream<PostWithCount>.value(
        PostWithCount(posts: const [], count: 0),
      ).asBroadcastStream();

  Future<void> emit(List<Post> posts) async {
    controller.add(posts);
    await Future<void>.value();
  }

  Future<void> emitError(Object error) async {
    controller.addError(error);
    await Future<void>.value();
  }

  Future<void> close() => controller.close();
}

class FakeInteractionsServices implements InteractionsServices {
  List<Interaction> interactions = [];
  final List<Interaction> ajouts = [];

  @override
  String get table => 'interactions';

  @override
  Future addData(Interaction item) async {
    ajouts.add(item);
  }

  @override
  Future deletedata(Interaction item) async {}

  @override
  Future<List<Interaction>> readDataOnce(int postId) async => interactions;

  @override
  Future<InteractionWithCount> readUserData(String userId) async =>
      InteractionWithCount(
        interactions: interactions,
        count: interactions.length,
      );

  @override
  Future updateData(Interaction item) async {}
}

class FakeStorageServices implements StorageServices {
  @override
  Future<String> addData(XFile item) async => 'https://storage.test/image.jpg';

  @override
  Future deletedata(XFile item) async {}

  @override
  Future readDataOnce(String id) async {}

  @override
  Future updateData(XFile item) async {}
}

/// Dépôt d'authentification pilotable : aucun backend, état explicite.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    AuthSessionStatus statutInitial = AuthSessionStatus.unknown,
  }) : _session = AuthSessionState(status: statutInitial);

  final StreamController<AuthSessionState> _controller =
      StreamController<AuthSessionState>.broadcast();

  AuthSessionState _session;
  int initializeCalls = 0;
  int guestCalls = 0;
  int elevateCalls = 0;
  int signInCalls = 0;
  int signOutCalls = 0;
  Object? erreurElevation;
  String dernierPseudo = '';

  @override
  Stream<AuthSessionState> get state => _controller.stream;

  @override
  AuthSessionState get current => _session;

  void emit(AuthSessionState session) {
    _session = session;
    _controller.add(session);
  }

  void devenirInvite({Object? erreur}) => emit(
    AuthSessionState(
      status: AuthSessionStatus.guest,
      authUserId: 'invite-1',
      error: erreur,
    ),
  );

  void devenirAuthentifie() => emit(
    const AuthSessionState(
      status: AuthSessionStatus.authenticated,
      authUserId: 'utilisateur-1',
      pseudo: 'joueur_1',
    ),
  );

  @override
  Future<void> initialize() async {
    initializeCalls++;
  }

  @override
  Future<void> signInAsGuest() async {
    guestCalls++;
    devenirInvite();
  }

  @override
  Future<void> elevate({
    required String pseudo,
    required String password,
  }) async {
    elevateCalls++;
    dernierPseudo = pseudo;
    final Object? erreur = erreurElevation;
    if (erreur != null) throw erreur;
    devenirAuthentifie();
  }

  @override
  Future<void> signIn({
    required String pseudo,
    required String password,
  }) async {
    signInCalls++;
    dernierPseudo = pseudo;
    devenirAuthentifie();
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    devenirInvite();
  }

  Future<void> close() => _controller.close();
}

Post buildPost({
  int id = 1,
  String question = 'Question du duel',
  String type = 'text',
  String? user,
  String nom = 'Adamou',
  String createdAt = '2026-10-19',
  String optionAText = 'Option A',
  String optionBText = 'Option B',
}) {
  return Post(
    id: id,
    created_at: createdAt,
    question: question,
    type: type,
    user: user,
    nom: nom,
    option_a_text: type == 'text' ? optionAText : null,
    option_b_text: type == 'text' ? optionBText : null,
    option_a_url: type == 'image' ? 'https://img.test/a.jpg' : null,
    option_b_url: type == 'image' ? 'https://img.test/b.jpg' : null,
  );
}
