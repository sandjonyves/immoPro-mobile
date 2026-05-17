import '../entities/terrain.dart';
import '../repositories/i_terrain_repository.dart';
import '../value_objects/borne.dart';
import '../value_objects/statut_terrain.dart';

class CreerTerrainInput {
  final String titre;
  final List<Borne> bornes;
  final StatutTerrain statut;
  final double prix;
  final String ville;
  final String quartier;
  final String description;
  final String titreFoncier;
  final String agentId;
  final String agentWhatsapp;
  final List<String> photos;
  final List<String> documents;

  CreerTerrainInput({
    required this.titre,
    required this.bornes,
    required this.statut,
    required this.prix,
    required this.ville,
    required this.quartier,
    required this.description,
    required this.titreFoncier,
    required this.agentId,
    required this.agentWhatsapp,
    this.photos = const [],
    this.documents = const [],
  });
}

class CreerTerrain {
  final ITerrainRepository _repository;
  final IdGenerateurTerrain _ids;

  CreerTerrain(this._repository, this._ids);

  Future<Terrain> execute(CreerTerrainInput input) async {
    final id = _ids.nouveau();
    final terrain = Terrain.creer(
      id: id,
      titre: input.titre,
      bornes: input.bornes,
      statut: input.statut,
      prix: input.prix,
      ville: input.ville,
      quartier: input.quartier,
      description: input.description,
      titreFoncier: input.titreFoncier,
      agentId: input.agentId,
      agentWhatsapp: input.agentWhatsapp,
      photos: input.photos,
      documents: input.documents,
    );
    await _repository.enregistrer(terrain);
    return terrain;
  }
}

abstract interface class IdGenerateurTerrain {
  String nouveau();
}
