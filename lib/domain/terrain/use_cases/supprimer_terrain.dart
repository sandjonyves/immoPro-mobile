import '../../shared/errors/domain_error.dart';
import '../repositories/i_terrain_repository.dart';

class SupprimerTerrain {
  final ITerrainRepository _repository;
  const SupprimerTerrain(this._repository);

  Future<void> execute(String id) async {
    final existing = await _repository.parId(id);
    if (existing == null) {
      throw const DomainError('Terrain introuvable.');
    }
    await _repository.supprimer(id);
  }
}
