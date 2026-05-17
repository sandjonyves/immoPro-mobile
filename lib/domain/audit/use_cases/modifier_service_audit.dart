import '../../shared/errors/domain_error.dart';
import '../repositories/i_audit_repository.dart';
import '../value_objects/categorie_audit.dart';
import '../value_objects/tarif_audit.dart';

class ModifierServiceAuditInput {
  final String id;
  final String? titre;
  final String? description;
  final String? descriptionDetaillee;
  final CategorieAudit? categorie;
  final TarifAudit? tarif;
  final List<String>? inclusions;
  final List<String>? documents;
  final String? dureeEstimee;
  final String? whatsappNumero;
  final bool? actif;

  const ModifierServiceAuditInput({
    required this.id,
    this.titre,
    this.description,
    this.descriptionDetaillee,
    this.categorie,
    this.tarif,
    this.inclusions,
    this.documents,
    this.dureeEstimee,
    this.whatsappNumero,
    this.actif,
  });
}

class ModifierServiceAudit {
  final IAuditRepository _repository;
  const ModifierServiceAudit(this._repository);

  Future<void> execute(ModifierServiceAuditInput input) async {
    final existing = await _repository.parId(input.id);
    if (existing == null) {
      throw const DomainError('Service introuvable.');
    }
    await _repository.enregistrer(
      existing.copyWith(
        titre: input.titre,
        description: input.description,
        descriptionDetaillee: input.descriptionDetaillee,
        categorie: input.categorie,
        tarif: input.tarif,
        inclusions: input.inclusions,
        documents: input.documents,
        dureeEstimee: input.dureeEstimee,
        whatsappNumero: input.whatsappNumero,
        actif: input.actif,
      ),
    );
  }
}
