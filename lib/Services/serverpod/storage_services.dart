import 'dart:typed_data';

import 'package:avis/Services/serverpod/client.dart';
import 'package:avis_client/avis_client.dart';
import 'package:image_picker/image_picker.dart';

/// Adaptateur de stockage : les octets sont envoyés à l'endpoint authentifié
/// qui dérive le dossier de la session serveur.
class StorageServices {
  StorageServices({Client? client}) : _client = client ?? serverpodClient;

  final Client _client;

  Future<String> addData(XFile item) async {
    final Uint8List octets = await item.readAsBytes();
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final Uri uri = await _client.user.uploadImage(
      ByteData.sublistView(octets),
      fileName,
    );
    return uri.toString();
  }

  Future<dynamic> deletedata(XFile item) async {
    throw UnimplementedError(
      'Le backend Serverpod n\'expose pas encore la suppression d\'une image',
    );
  }

  Future<dynamic> readDataOnce(String id) async {
    throw UnimplementedError(
      'Le backend Serverpod n\'expose pas encore la lecture d\'une image',
    );
  }

  Future<dynamic> updateData(XFile item) async {
    throw UnimplementedError(
      'Le backend Serverpod n\'expose pas encore la modification d\'une image',
    );
  }
}
