import '../repositories/i_favoris_repository.dart';

class BasculerFavoriMaison {
  final IFavorisRepository _repository;
  const BasculerFavoriMaison(this._repository);

  Future<void> execute(String maisonId) => _repository.basculerMaison(maisonId);
}
