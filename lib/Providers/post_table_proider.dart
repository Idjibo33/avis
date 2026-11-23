import 'package:avis/Helpers/snackbar.dart';
import 'package:avis/Models/post.dart';
import 'package:avis/Services/serverpod/posts_table_services.dart';
import 'package:avis/Services/serverpod/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostTableProider extends ChangeNotifier {
  final PostsTableServices _postsTableServices;
  final StorageServices _storageServices;

  PostTableProider({
    PostsTableServices? postsTableServices,
    StorageServices? storageServices,
  }) : _postsTableServices = postsTableServices ?? PostsTableServices(),
       _storageServices = storageServices ?? StorageServices();

  bool _chargement = false;
  bool get chargement => _chargement;
  String _message = "";
  Stream<List<Post>> get streamPosts => _postsTableServices.readData();

  /// Renvoie explicitement le succès de l'écriture : les formulaires ne vident
  /// leurs champs que sur une publication effectivement confirmée.
  Future<bool> addPost({
    required Post post,
    XFile? optionA,
    XFile? optionB,
    String? userId,
  }) async {
    try {
      _chargement = true;
      notifyListeners();
      if (post.type == 'image') {
        final urlImageA = await _storageServices.addData(optionA!);
        final urlImageB = await _storageServices.addData(optionB!);
        await _postsTableServices.addData(
          Post(
            question: post.question,
            type: post.type,
            option_a_url: urlImageA,
            option_b_url: urlImageB,
          ),
        );
      } else {
        await _postsTableServices.addData(post);
      }
      _chargement = false;
      _message = "Succès : Duel ajouté";
      showSuccess(_message);
      notifyListeners();
      return true;
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      showError(_message);
      notifyListeners();
      return false;
    }
  }

  Future removePost({required Post post}) async {
    try {
      _chargement = true;
      notifyListeners();
      await _postsTableServices.deletedata(post);
      _chargement = false;
      _message = "Succès : Post ajouté";
      notifyListeners();
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
    }
  }

  Future updatePost({required Post post}) async {
    try {
      _chargement = true;
      notifyListeners();
      await _postsTableServices.updateData(post);
      _chargement = false;
      _message = "Succès : Post ajouté";
      notifyListeners();
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
    }
  }

  /// Un flux ne doit pas être partagé entre les widgets du profil : le rejeu du
  /// cache est consommé par le premier abonné d'un flux broadcast, et le second
  /// resterait en `waiting` (spinner infini). Chaque appel crée donc son flux.
  Stream<PostWithCount>? readUserPost({required String userId}) {
    try {
      return _postsTableServices.getUserPosts(userId);
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      return null;
    }
  }
}
