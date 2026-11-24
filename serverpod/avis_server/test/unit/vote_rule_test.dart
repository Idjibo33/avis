import 'package:avis_server/src/endpoints/user_endpoint.dart';
import 'package:avis_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

Duel _duel(UuidValue auteur) => Duel(
      authorId: auteur,
      authorName: 'Auteur',
      question: 'Un duel',
      type: 'text',
    );

void main() {
  final UuidValue auteur = UuidValue.fromString(
    '11111111-1111-4111-8111-111111111111',
  );
  final UuidValue autre = UuidValue.fromString(
    '22222222-2222-4222-8222-222222222222',
  );

  test('le créateur ne peut pas voter pour son propre duel', () {
    expect(
      motifRefusVote(_duel(auteur), auteur),
      "Vous ne pouvez pas voter pour votre propre duel.",
    );
  });

  test('un autre utilisateur peut voter', () {
    expect(motifRefusVote(_duel(auteur), autre), isNull);
  });
}
