import 'package:avis/Models/post.dart';
import 'package:flutter/material.dart';

/// Phases de la liste des duels de l'utilisateur sur le profil.
///
/// S29 (`docs/state-machines.md`) : un `StreamBuilder` sans état explicite
/// affichait un spinner dès qu'il n'y avait pas de donnée, y compris sur erreur
/// et sur un flux qui ne réémet jamais. La vue ne fait plus que `switch`.
enum ProfilePostsStatus { chargement, pret, vide, invite, echec }

class ProfilePostsViewState {
  const ProfilePostsViewState._(this.statut, this.posts);

  final ProfilePostsStatus statut;
  final List<Post> posts;

  /// Un invité n'a pas de duels à charger : aucun `userId!`, aucun flux.
  factory ProfilePostsViewState.from(
    AsyncSnapshot<PostWithCount>? snapshot, {
    required bool invite,
  }) {
    if (invite) {
      return const ProfilePostsViewState._(ProfilePostsStatus.invite, []);
    }
    if (snapshot == null ||
        (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData)) {
      return const ProfilePostsViewState._(ProfilePostsStatus.chargement, []);
    }
    if (snapshot.hasError) {
      return const ProfilePostsViewState._(ProfilePostsStatus.echec, []);
    }
    final PostWithCount? donnees = snapshot.data;
    final List<Post> posts = donnees?.posts ?? const <Post>[];
    if ((donnees?.count ?? 0) == 0 || posts.isEmpty) {
      return const ProfilePostsViewState._(ProfilePostsStatus.vide, []);
    }
    return ProfilePostsViewState._(ProfilePostsStatus.pret, posts);
  }
}
