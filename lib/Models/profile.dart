class Profile {
  final String? id;
  final String nom;
  final String prenom;
  final String email;
  Profile({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });
  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'nom': nom, 'prenom': prenom, 'email': email};
  }
}
