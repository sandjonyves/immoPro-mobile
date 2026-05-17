import '../entities/terrain.dart';
import '../repositories/i_terrain_repository.dart';

class ListerTerrains {
  final ITerrainRepository _repository;
  const ListerTerrains(this._repository);

  Future<List<Terrain>> execute() => _repository.tous();
}
