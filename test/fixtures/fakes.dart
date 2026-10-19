import 'dart:async';

import 'package:avis/Models/interaction.dart';
import 'package:avis/Models/post.dart';
import 'package:avis/Models/profile.dart';
import 'package:avis/Services/Supabase/auth_services.dart';
import 'package:avis/Services/Supabase/interactions_services.dart';
import 'package:avis/Services/Supabase/posts_table_services.dart';
import 'package:avis/Services/Supabase/profile_table_services.dart';
import 'package:avis/Services/Supabase/storage_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FakeAuthServices implements AuthServices {
  @override
  Stream<AuthState> get authState => const Stream<AuthState>.empty();

  @override
  Future createUserWithEmail(String email, String password) async {}

  @override
  Future signInUserAnonynously() async {}

  @override
  Future signInUserWithEmail(String email, String password) async {}

  @override
  Future signInUserWithGoogle() async {}

  @override
  Future signOut() async {}
}

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
      Stream.value(PostWithCount(posts: const [], count: 0));

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

  @override
  String get table => 'interactions';

  @override
  Future addData(Interaction item) async {}

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

Post buildPost({
  int id = 1,
  String question = 'Question du duel',
  String type = 'text',
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
    nom: nom,
    option_a_text: type == 'text' ? optionAText : null,
    option_b_text: type == 'text' ? optionBText : null,
    option_a_url: type == 'image' ? 'https://img.test/a.jpg' : null,
    option_b_url: type == 'image' ? 'https://img.test/b.jpg' : null,
  );
}
