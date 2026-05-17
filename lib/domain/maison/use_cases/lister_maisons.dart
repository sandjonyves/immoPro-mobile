import '../entities/maison.dart';
import '../repositories/i_maison_repository.dart';

class ListerMaisons {
  final IMaisonRepository _repository;
  const ListerMaisons(this._repository);

  Future<List<Maison>> execute() => _repository.tous();
}
