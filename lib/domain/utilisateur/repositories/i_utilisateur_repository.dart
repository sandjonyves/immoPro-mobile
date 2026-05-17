import '../entities/utilisateur.dart';

abstract interface class IUtilisateurRepository {
  Future<Utilisateur?> parEmail(String email);
  Future<List<Utilisateur>> tous();
  Future<Utilisateur?> parId(String id);
  Future<void> enregistrer(Utilisateur u);
  Future<void> supprimer(String id);
}
