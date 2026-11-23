import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../auth/logged_in_endpoint.dart';
import '../generated/protocol.dart';

/// Un duel n'est pas votable par son propre auteur. Règle serveur : un client
/// contournant l'UI ne peut pas écrire de vote sur sa création.
String? motifRefusVote(Duel duel, UuidValue votant) =>
    duel.authorId == votant
        ? "Vous ne pouvez pas voter pour votre propre duel."
        : null;

/// Écritures authentifiées. Toutes les identités sont dérivées de la session :
/// aucun identifiant d'utilisateur n'est accepté en paramètre.
class UserEndpoint extends LoggedInEndpoint {
  static final RegExp _usernamePattern = RegExp(r'^[A-Za-z0-9_]{3,20}$');

  /// Crée un duel dont l'auteur est l'utilisateur connecté.
  Future<Duel> createDuel(
    Session session,
    String question,
    String type,
    String? optionAText,
    String? optionAUrl,
    String? optionBText,
    String? optionBUrl,
  ) async {
    final trimmedQuestion = question.trim();
    if (trimmedQuestion.isEmpty || trimmedQuestion.length > 500) {
      throw const FormatException('Question invalide.');
    }
    if (type != 'text' && type != 'image') {
      throw const FormatException('Type de duel invalide.');
    }

    final authUserId = session.authenticated!.authUserId;
    return Duel.db.insertRow(
      session,
      Duel(
        authorId: authUserId,
        authorName: await _displayName(session, authUserId),
        question: trimmedQuestion,
        type: type,
        optionAText: optionAText,
        optionAUrl: optionAUrl,
        optionBText: optionBText,
        optionBUrl: optionBUrl,
      ),
    );
  }

  /// Vote pour le duel [duelId]. Un seul vote par utilisateur et par duel :
  /// un second appel remplace le choix précédent. L'auteur est refusé : la
  /// vérification est faite ici, côté serveur, pas seulement dans l'UI.
  Future<Vote> vote(Session session, int duelId, String choix) async {
    if (choix != 'a' && choix != 'b') {
      throw const FormatException('Choix invalide.');
    }
    final duel = await Duel.db.findFirstRow(
      session,
      where: (t) => t.id.equals(duelId),
    );
    if (duel == null) {
      throw const FormatException('Duel introuvable.');
    }

    final authUserId = session.authenticated!.authUserId;
    final String? motifRefus = motifRefusVote(duel, authUserId);
    if (motifRefus != null) {
      throw FormatException(motifRefus);
    }
    final existing = await Vote.db.findFirstRow(
      session,
      where: (t) => t.duelId.equals(duelId) & t.userId.equals(authUserId),
    );
    if (existing != null) {
      existing.choix = choix;
      return Vote.db.updateRow(session, existing);
    }
    return Vote.db.insertRow(
      session,
      Vote(duelId: duelId, userId: authUserId, choix: choix),
    );
  }

  /// Met à jour le pseudo de l'utilisateur connecté.
  Future<String> updateProfile(Session session, String pseudo) async {
    final username = pseudo.trim();
    if (!_usernamePattern.hasMatch(username)) {
      throw const FormatException('Pseudo invalide.');
    }
    final normalized = username.toLowerCase();
    final authUserId = session.authenticated!.authUserId;

    final account = await UsernameAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    final taken = await UsernameAccount.db.findFirstRow(
      session,
      where: (t) => t.usernameNormalized.equals(normalized),
    );
    if (taken != null && taken.authUserId != authUserId) {
      throw const FormatException('Pseudo indisponible.');
    }

    if (account != null) {
      account.username = username;
      account.usernameNormalized = normalized;
      await UsernameAccount.db.updateRow(session, account);
    }
    await AuthServices.instance.userProfiles.changeUserName(
      session,
      authUserId,
      username,
    );
    return username;
  }

  /// Stocke une image dans le stockage public et renvoie son URL.
  Future<Uri> uploadImage(
    Session session,
    ByteData bytes,
    String fileName,
  ) async {
    final authUserId = session.authenticated!.authUserId;
    final extension = _extensionOf(fileName);
    final path =
        'duels/$authUserId/${DateTime.now().microsecondsSinceEpoch}$extension';

    await session.storage.storeFile(
      storageId: 'public',
      path: path,
      byteData: bytes,
    );
    return session.storage.publicDownloadUrl(storageId: 'public', path: path);
  }

  /// Supprime un duel, uniquement si l'utilisateur connecté en est l'auteur.
  Future<bool> deleteDuel(Session session, int duelId) async {
    final authUserId = session.authenticated!.authUserId;
    final duel = await Duel.db.findFirstRow(
      session,
      where: (t) => t.id.equals(duelId),
    );
    if (duel == null || duel.authorId != authUserId) {
      return false;
    }
    await Duel.db.deleteRow(session, duel);
    return true;
  }

  Future<String> _displayName(Session session, UuidValue authUserId) async {
    final account = await UsernameAccount.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId),
    );
    if (account != null) return account.username;
    final profile = await AuthServices.instance.userProfiles
        .maybeFindUserProfileByUserId(session, authUserId);
    return profile?.userName ?? 'Anonyme';
  }

  /// N'autorise qu'une extension de fichier simple, sans chemin ni `..`.
  String _extensionOf(String fileName) {
    final match = RegExp(
      r'(\.(png|jpe?g|webp|gif))$',
      caseSensitive: false,
    ).firstMatch(fileName.trim());
    return match?.group(1)?.toLowerCase() ?? '.jpg';
  }
}
