import '../../shared/errors/domain_error.dart';
import '../entities/utilisateur.dart';
import '../repositories/i_utilisateur_repository.dart';
import '../value_objects/statut_utilisateur.dart';

class SeConnecter {
  final IUtilisateurRepository _repository;
  const SeConnecter(this._repository);

  Future<Utilisateur> execute({
    required String email,
    required String motDePasse,
  }) async {
    final u = await _repository.parEmail(email.trim().toLowerCase());
    if (u == null || u.motDePasseHashOuClairDemo != motDePasse) {
      throw const DomainError('Identifiants incorrects.');
    }
    if (u.statut == StatutUtilisateur.suspendu) {
      throw const DomainError('Compte suspendu. Contactez un administrateur.');
    }
    return u;
  }
}
