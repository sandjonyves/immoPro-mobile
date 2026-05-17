import '../repositories/i_favoris_repository.dart';

class BasculerFavoriTerrain {
  final IFavorisRepository _repository;
  const BasculerFavoriTerrain(this._repository);

  Future<void> execute(String terrainId) =>
      _repository.basculerTerrain(terrainId);
}
