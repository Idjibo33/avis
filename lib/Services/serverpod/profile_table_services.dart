import 'dart:async';

import 'package:avis/Models/profile.dart';
import 'package:avis/Services/serverpod/client.dart';
import 'package:avis_client/avis_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Adaptateur du profil. Le backend n'expose qu'un pseudo modifiable : les
/// autres champs du modèle historique restent vides en lecture.
class ProfileTableServices {
  ProfileTableServices({Client? client}) : _client = client ?? serverpodClient;

  final Client _client;
  final String table = 'profiles';

  int _abonnes = 0;
  late final StreamController<List<Profile>> _controller =
      StreamController<List<Profile>>.broadcast(
        onListen: () {
          _abonnes++;
          if (_abonnes == 1) unawaited(_rafraichir());
        },
        onCancel: () {
          if (_abonnes > 0) _abonnes--;
        },
      );

  Stream<List<Profile>> readData() => _controller.stream;

  Future<Profile> readDataOnce(String id) async {
    final String? pseudo = await _client.publicFeed.authorName(
      UuidValue.fromString(id),
    );
    return Profile(id: id, nom: pseudo ?? '', prenom: '', email: '');
  }

  Future<dynamic> addData(Profile item) async {
    await _client.user.updateProfile(item.nom);
    await _rafraichir();
  }

  Future<dynamic> updateData(Profile item) async {
    await _client.user.updateProfile(item.nom);
    await _rafraichir();
  }

  Future<dynamic> deletedata(Profile item) async {
    throw UnimplementedError(
      'Le backend Serverpod n\'expose pas encore la suppression d\'un profil',
    );
  }

  Future<void> _rafraichir() async {
    try {
      final String? id = _client.auth.authInfo?.authUserId.toString();
      final List<Profile> profils = id == null
          ? const <Profile>[]
          : <Profile>[await readDataOnce(id)];
      if (!_controller.isClosed) _controller.add(profils);
    } catch (error, stackTrace) {
      if (!_controller.isClosed) _controller.addError(error, stackTrace);
    }
  }
}
