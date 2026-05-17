import '../../shared/errors/domain_error.dart';
import '../repositories/i_maison_repository.dart';

class SupprimerMaison {
  final IMaisonRepository _repository;
  const SupprimerMaison(this._repository);

  Future<void> execute(String id) async {
    final existing = await _repository.parId(id);
    if (existing == null) {
      throw const DomainError('Maison introuvable.');
    }
    await _repository.supprimer(id);
  }
}
