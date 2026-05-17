import '../repositories/i_favoris_repository.dart';

class ObtenirFavoris {
  final IFavorisRepository _repository;
  const ObtenirFavoris(this._repository);

  Future<({Set<String> terrains, Set<String> maisons})> execute() async {
    final t = await _repository.terrainsFavoris();
    final m = await _repository.maisonsFavoris();
    return (terrains: t, maisons: m);
  }
}
