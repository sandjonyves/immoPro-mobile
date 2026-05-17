import '../entities/terrain.dart';
import '../repositories/i_terrain_repository.dart';

class RechercherTerrains {
  final ITerrainRepository _repository;
  const RechercherTerrains(this._repository);

  Future<List<Terrain>> execute(CritereRechercheTerrain criteres) async {
    final list = await _repository.tous();
    Iterable<Terrain> r = list;

    final q = criteres.query?.trim().toLowerCase();
    if (q != null && q.isNotEmpty) {
      r = r.where((t) {
        return t.titre.toLowerCase().contains(q) ||
            t.quartier.toLowerCase().contains(q) ||
            t.ville.toLowerCase().contains(q) ||
            t.description.toLowerCase().contains(q);
      });
    }
    if (criteres.statut != null) {
      r = r.where((t) => t.statut == criteres.statut);
    }
    if (criteres.prixMin != null) {
      r = r.where((t) => t.prix >= criteres.prixMin!);
    }
    if (criteres.prixMax != null) {
      r = r.where((t) => t.prix <= criteres.prixMax!);
    }
    if (criteres.surfaceMin != null) {
      r = r.where((t) => t.surfaceM2.valeur >= criteres.surfaceMin!);
    }
    if (criteres.surfaceMax != null) {
      r = r.where((t) => t.surfaceM2.valeur <= criteres.surfaceMax!);
    }
    if (criteres.ville != null && criteres.ville!.isNotEmpty) {
      final v = criteres.ville!.toLowerCase();
      r = r.where((t) => t.ville.toLowerCase() == v);
    }

    return r.toList();
  }
}
