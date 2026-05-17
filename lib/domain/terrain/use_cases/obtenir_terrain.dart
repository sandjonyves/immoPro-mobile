import '../entities/terrain.dart';
import '../repositories/i_terrain_repository.dart';

class ObtenirTerrain {
  final ITerrainRepository _repository;
  const ObtenirTerrain(this._repository);

  Future<Terrain?> execute(String id) => _repository.parId(id);
}
