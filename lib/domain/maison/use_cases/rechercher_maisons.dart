import '../entities/maison.dart';
import '../repositories/i_maison_repository.dart';

class RechercherMaisons {
  final IMaisonRepository _repository;
  const RechercherMaisons(this._repository);

  Future<List<Maison>> execute(CritereRechercheMaison criteres) async {
    final list = await _repository.tous();
    Iterable<Maison> r = list;

    final q = criteres.query?.trim().toLowerCase();
    if (q != null && q.isNotEmpty) {
      r = r.where((m) {
        return m.titre.toLowerCase().contains(q) ||
            m.quartier.toLowerCase().contains(q) ||
            m.ville.toLowerCase().contains(q);
      });
    }
    if (criteres.statut != null) {
      r = r.where((m) => m.statut == criteres.statut);
    }
    if (criteres.type != null) {
      r = r.where((m) => m.type == criteres.type);
    }
    if (criteres.prixMin != null) {
      r = r.where((m) => m.prix >= criteres.prixMin!);
    }
    if (criteres.prixMax != null) {
      r = r.where((m) => m.prix <= criteres.prixMax!);
    }
    if (criteres.chambresMin != null) {
      r = r.where((m) => m.chambres >= criteres.chambresMin!);
    }
    if (criteres.ville != null && criteres.ville!.isNotEmpty) {
      final v = criteres.ville!.toLowerCase();
      r = r.where((m) => m.ville.toLowerCase() == v);
    }

    return r.toList();
  }
}
