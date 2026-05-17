import '../entities/terrain.dart';
import '../value_objects/statut_terrain.dart';

abstract interface class ITerrainRepository {
  Future<List<Terrain>> tous();
  Future<Terrain?> parId(String id);
  Future<void> enregistrer(Terrain terrain);
  Future<void> supprimer(String id);
}

class CritereRechercheTerrain {
  final String? query;
  final StatutTerrain? statut;
  final double? prixMin;
  final double? prixMax;
  final double? surfaceMin;
  final double? surfaceMax;
  final String? ville;

  const CritereRechercheTerrain({
    this.query,
    this.statut,
    this.prixMin,
    this.prixMax,
    this.surfaceMin,
    this.surfaceMax,
    this.ville,
  });
}
