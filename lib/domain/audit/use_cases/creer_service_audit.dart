import '../entities/service_audit.dart';
import '../repositories/i_audit_repository.dart';
import '../value_objects/categorie_audit.dart';
import '../value_objects/tarif_audit.dart';

class CreerServiceAuditInput {
  final String titre;
  final String description;
  final String descriptionDetaillee;
  final CategorieAudit categorie;
  final TarifAudit tarif;
  final List<String> inclusions;
  final List<String> documents;
  final String dureeEstimee;
  final String whatsappNumero;

  CreerServiceAuditInput({
    required this.titre,
    required this.description,
    required this.descriptionDetaillee,
    required this.categorie,
    required this.tarif,
    required this.inclusions,
    required this.documents,
    required this.dureeEstimee,
    required this.whatsappNumero,
  });
}

abstract interface class IdGenerateurAudit {
  String nouveau();
}

class CreerServiceAudit {
  final IAuditRepository _repository;
  final IdGenerateurAudit _ids;

  CreerServiceAudit(this._repository, this._ids);

  Future<ServiceAudit> execute(CreerServiceAuditInput input) async {
    final s = ServiceAudit(
      id: _ids.nouveau(),
      titre: input.titre,
      description: input.description,
      descriptionDetaillee: input.descriptionDetaillee,
      categorie: input.categorie,
      tarif: input.tarif,
      inclusions: List.unmodifiable(input.inclusions),
      documents: List.unmodifiable(input.documents),
      dureeEstimee: input.dureeEstimee,
      whatsappNumero: input.whatsappNumero,
      actif: true,
    );
    await _repository.enregistrer(s);
    return s;
  }
}
