import '../../shared/errors/domain_error.dart';
import '../entities/utilisateur.dart';
import '../repositories/i_utilisateur_repository.dart';

class ObtenirProfil {
  final IUtilisateurRepository _repository;
  const ObtenirProfil(this._repository);

  Future<Utilisateur> execute(String userId) async {
    final u = await _repository.parId(userId);
    if (u == null) {
      throw const DomainError('Utilisateur introuvable.');
    }
    return u;
  }
}
