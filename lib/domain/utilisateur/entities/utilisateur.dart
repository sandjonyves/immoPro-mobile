import '../value_objects/role.dart';
import '../value_objects/statut_utilisateur.dart';

class Utilisateur {
  final String id;
  final String nom;
  final String email;
  final String telephone;
  final Role role;
  final StatutUtilisateur statut;
  final String motDePasseHashOuClairDemo;
  final DateTime dateInscription;

  const Utilisateur({
    required this.id,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.role,
    required this.statut,
    required this.motDePasseHashOuClairDemo,
    required this.dateInscription,
  });

  Utilisateur copyWith({
    String? nom,
    Role? role,
    StatutUtilisateur? statut,
    String? telephone,
  }) {
    return Utilisateur(
      id: id,
      nom: nom ?? this.nom,
      email: email,
      telephone: telephone ?? this.telephone,
      role: role ?? this.role,
      statut: statut ?? this.statut,
      motDePasseHashOuClairDemo: motDePasseHashOuClairDemo,
      dateInscription: dateInscription,
    );
  }
}
