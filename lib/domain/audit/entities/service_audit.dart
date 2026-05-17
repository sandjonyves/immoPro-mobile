import '../value_objects/categorie_audit.dart';
import '../value_objects/tarif_audit.dart';

class ServiceAudit {
  final String id;
  final String titre;
  final String description;
  final String descriptionDetaillee;
  final CategorieAudit categorie;
  final TarifAudit tarif;
  final List<String> inclusions;
  final List<String> documents;
  final String dureeEstimee;
  final String whatsappNumero;
  final bool actif;

  const ServiceAudit({
    required this.id,
    required this.titre,
    required this.description,
    required this.descriptionDetaillee,
    required this.categorie,
    required this.tarif,
    required this.inclusions,
    required this.documents,
    required this.dureeEstimee,
    required this.whatsappNumero,
    required this.actif,
  });

  ServiceAudit copyWith({
    String? titre,
    String? description,
    String? descriptionDetaillee,
    CategorieAudit? categorie,
    TarifAudit? tarif,
    List<String>? inclusions,
    List<String>? documents,
    String? dureeEstimee,
    String? whatsappNumero,
    bool? actif,
  }) {
    return ServiceAudit(
      id: id,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      descriptionDetaillee: descriptionDetaillee ?? this.descriptionDetaillee,
      categorie: categorie ?? this.categorie,
      tarif: tarif ?? this.tarif,
      inclusions: List.unmodifiable(inclusions ?? this.inclusions),
      documents: List.unmodifiable(documents ?? this.documents),
      dureeEstimee: dureeEstimee ?? this.dureeEstimee,
      whatsappNumero: whatsappNumero ?? this.whatsappNumero,
      actif: actif ?? this.actif,
    );
  }
}
