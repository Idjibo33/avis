/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Un duel du feed (anciennement « post » dans l'app Flutter).
abstract class Duel
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Duel._({
    this.id,
    DateTime? createdAt,
    required this.authorId,
    required this.authorName,
    required this.question,
    required this.type,
    this.optionAText,
    this.optionAUrl,
    this.optionBText,
    this.optionBUrl,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Duel({
    int? id,
    DateTime? createdAt,
    required _isc.UuidValue authorId,
    required String authorName,
    required String question,
    required String type,
    String? optionAText,
    String? optionAUrl,
    String? optionBText,
    String? optionBUrl,
  }) = _DuelImpl;

  factory Duel.fromJson(Map<String, dynamic> jsonSerialization) {
    return Duel(
      id: jsonSerialization['id'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      authorId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authorId'],
      ),
      authorName: jsonSerialization['authorName'] as String,
      question: jsonSerialization['question'] as String,
      type: jsonSerialization['type'] as String,
      optionAText: jsonSerialization['optionAText'] as String?,
      optionAUrl: jsonSerialization['optionAUrl'] as String?,
      optionBText: jsonSerialization['optionBText'] as String?,
      optionBUrl: jsonSerialization['optionBUrl'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime createdAt;

  /// UUID de l'auteur, jamais fourni par le client en écriture.
  _isc.UuidValue authorId;

  /// Pseudo de l'auteur au moment de la création (lecture seule pour le feed).
  String authorName;

  String question;

  /// "text" ou "image".
  String type;

  String? optionAText;

  String? optionAUrl;

  String? optionBText;

  String? optionBUrl;

  /// Returns a shallow copy of this [Duel]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Duel copyWith({
    int? id,
    DateTime? createdAt,
    _isc.UuidValue? authorId,
    String? authorName,
    String? question,
    String? type,
    String? optionAText,
    String? optionAUrl,
    String? optionBText,
    String? optionBUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Duel',
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      'authorId': authorId.toJson(),
      'authorName': authorName,
      'question': question,
      'type': type,
      if (optionAText != null) 'optionAText': optionAText,
      if (optionAUrl != null) 'optionAUrl': optionAUrl,
      if (optionBText != null) 'optionBText': optionBText,
      if (optionBUrl != null) 'optionBUrl': optionBUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Duel',
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      'authorId': authorId.toJson(),
      'authorName': authorName,
      'question': question,
      'type': type,
      if (optionAText != null) 'optionAText': optionAText,
      if (optionAUrl != null) 'optionAUrl': optionAUrl,
      if (optionBText != null) 'optionBText': optionBText,
      if (optionBUrl != null) 'optionBUrl': optionBUrl,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DuelImpl extends Duel {
  _DuelImpl({
    int? id,
    DateTime? createdAt,
    required _isc.UuidValue authorId,
    required String authorName,
    required String question,
    required String type,
    String? optionAText,
    String? optionAUrl,
    String? optionBText,
    String? optionBUrl,
  }) : super._(
         id: id,
         createdAt: createdAt,
         authorId: authorId,
         authorName: authorName,
         question: question,
         type: type,
         optionAText: optionAText,
         optionAUrl: optionAUrl,
         optionBText: optionBText,
         optionBUrl: optionBUrl,
       );

  /// Returns a shallow copy of this [Duel]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Duel copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    _isc.UuidValue? authorId,
    String? authorName,
    String? question,
    String? type,
    Object? optionAText = _Undefined,
    Object? optionAUrl = _Undefined,
    Object? optionBText = _Undefined,
    Object? optionBUrl = _Undefined,
  }) {
    return Duel(
      id: id is int? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      question: question ?? this.question,
      type: type ?? this.type,
      optionAText: optionAText is String? ? optionAText : this.optionAText,
      optionAUrl: optionAUrl is String? ? optionAUrl : this.optionAUrl,
      optionBText: optionBText is String? ? optionBText : this.optionBText,
      optionBUrl: optionBUrl is String? ? optionBUrl : this.optionBUrl,
    );
  }
}
