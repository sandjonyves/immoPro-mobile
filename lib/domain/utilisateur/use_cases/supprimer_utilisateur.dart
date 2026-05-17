import '../../shared/errors/domain_error.dart';
import '../repositories/i_utilisateur_repository.dart';

class SupprimerUtilisateur {
  final IUtilisateurRepository _repository;
  const SupprimerUtilisateur(this._repository);

  Future<void> execute(String id) async {
    final existing = await _repository.parId(id);
    if (existing == null) {
      throw const DomainError('Utilisateur introuvable.');
    }
    await _repository.supprimer(id);
  }
}
