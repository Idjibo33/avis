class Post {
  final int? id;
  final String? created_at;
  final String? user;
  final String question;
  final String type;
  final String? nom;

  final String? option_a_text;
  final String? option_a_url;
  final String? option_b_text;
  final String? option_b_url;
  Post({
    this.id,
    this.created_at,
    this.user,
    required this.question,
    required this.type,
    this.option_a_text,
    this.option_a_url,
    this.option_b_text,
    this.option_b_url,
    this.nom,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      created_at: map['created_at'],
      user: map['user'],
      question: map['question'],
      option_a_text: map['option_a_text'],
      option_a_url: map['option_a_url'],
      option_b_text: map['option_b_text'],
      option_b_url: map['option_b_url'],
      type: map['type'],
      nom: map['nom'],
    );
  }
}
