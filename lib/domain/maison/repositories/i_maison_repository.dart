import '../entities/maison.dart';
import '../value_objects/statut_maison.dart';
import '../value_objects/type_maison.dart';

abstract interface class IMaisonRepository {
  Future<List<Maison>> tous();
  Future<Maison?> parId(String id);
  Future<void> enregistrer(Maison maison);
  Future<void> supprimer(String id);
}

class CritereRechercheMaison {
  final String? query;
  final StatutMaison? statut;
  final TypeMaison? type;
  final double? prixMin;
  final double? prixMax;
  final int? chambresMin;
  final String? ville;

  const CritereRechercheMaison({
    this.query,
    this.statut,
    this.type,
    this.prixMin,
    this.prixMax,
    this.chambresMin,
    this.ville,
  });
}
