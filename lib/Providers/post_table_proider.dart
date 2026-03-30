import 'dart:io';

import 'package:avis/Helpers/snackbar.dart';
import 'package:avis/Models/post.dart';
import 'package:avis/Services/Supabase/posts_table_services.dart';
import 'package:avis/Services/Supabase/storage_services.dart';
import 'package:flutter/material.dart';

class PostTableProider extends ChangeNotifier {
  final PostsTableServices _postsTableServices = PostsTableServices();
  final StorageServices _storageServices = StorageServices();
  bool _chargement = false;
  bool get chargement => _chargement;
  String _message = "";
  Stream<List<Post>> get streamPosts => _postsTableServices.readData();

  Future addPost({
    required Post post,
    File? optionA,
    File? optionB,
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
        _chargement = false;
        notifyListeners();
      } else {
        await _postsTableServices.addData(post);
        _chargement = false;
        _message = "Succès : Duel ajouté";
        showSuccess(_message);
        notifyListeners();
      }
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      showError(_message);
      notifyListeners();
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
