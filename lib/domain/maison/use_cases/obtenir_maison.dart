import '../entities/maison.dart';
import '../repositories/i_maison_repository.dart';

class ObtenirMaison {
  final IMaisonRepository _repository;
  const ObtenirMaison(this._repository);

  Future<Maison?> execute(String id) => _repository.parId(id);
}
