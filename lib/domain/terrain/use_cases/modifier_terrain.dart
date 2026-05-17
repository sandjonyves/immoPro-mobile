import '../../shared/errors/domain_error.dart';
import '../repositories/i_terrain_repository.dart';
import '../value_objects/borne.dart';
import '../value_objects/statut_terrain.dart';

class ModifierTerrainInput {
  final String id;
  final String? titre;
  final List<Borne>? bornes;
  final StatutTerrain? statut;
  final double? prix;
  final String? ville;
  final String? quartier;
  final String? description;
  final String? titreFoncier;
  final String? agentWhatsapp;
  final List<String>? photos;
  final List<String>? documents;

  const ModifierTerrainInput({
    required this.id,
    this.titre,
    this.bornes,
    this.statut,
    this.prix,
    this.ville,
    this.quartier,
    this.description,
    this.titreFoncier,
    this.agentWhatsapp,
    this.photos,
    this.documents,
  });
}

class ModifierTerrain {
  final ITerrainRepository _repository;
  const ModifierTerrain(this._repository);

  Future<void> execute(ModifierTerrainInput input) async {
    final existing = await _repository.parId(input.id);
    if (existing == null) {
      throw const DomainError('Terrain introuvable.');
    }
    final updated = existing.copyWith(
      titre: input.titre,
      bornes: input.bornes,
      statut: input.statut,
      prix: input.prix,
      ville: input.ville,
      quartier: input.quartier,
      description: input.description,
      titreFoncier: input.titreFoncier,
      agentWhatsapp: input.agentWhatsapp,
      photos: input.photos,
      documents: input.documents,
    );
    await _repository.enregistrer(updated);
  }
}
