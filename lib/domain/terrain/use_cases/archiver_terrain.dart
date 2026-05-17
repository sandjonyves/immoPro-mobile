import '../../shared/errors/domain_error.dart';
import '../repositories/i_terrain_repository.dart';

class ArchiverTerrain {
  final ITerrainRepository _repository;
  const ArchiverTerrain(this._repository);

  Future<void> execute(String id) async {
    final existing = await _repository.parId(id);
    if (existing == null) {
      throw const DomainError('Terrain introuvable.');
    }
    await _repository.enregistrer(existing.archiver());
  }
}
