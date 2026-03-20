class Interaction {
  int? id;
  int? postId;
  String? userId;
  String? choix;
  Interaction({this.id, this.postId, this.userId, required this.choix});

  factory Interaction.fromMap(Map<String, dynamic> map) {
    return Interaction(
      id: map['id'],
      postId: map['post'],
      userId: map['user'],
      choix: map['choix'],
    );
  }
}

class InteractionWithCount {
  List<Interaction>? interactions;
  int? count;
  InteractionWithCount({this.interactions, this.count});
  factory InteractionWithCount.fromMap(Map<String, dynamic> map) {
    final List data = map['data'];
    return InteractionWithCount(
      interactions: data.map((e) => Interaction.fromMap(e)).toList(),
      count: data.length,
    );
  }
}
