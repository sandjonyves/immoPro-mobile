import '../../shared/errors/domain_error.dart';
import '../value_objects/borne.dart';
import '../value_objects/statut_terrain.dart';
import '../value_objects/surface_terrain.dart';

class Terrain {
  final String id;
  final String titre;
  final List<Borne> bornes;
  final SurfaceTerrain surfaceM2;
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
  final DateTime dateAjout;

  const Terrain._({
    required this.id,
    required this.titre,
    required this.bornes,
    required this.surfaceM2,
    required this.statut,
    required this.prix,
    required this.ville,
    required this.quartier,
    required this.description,
    required this.titreFoncier,
    required this.agentId,
    required this.agentWhatsapp,
    required this.photos,
    required this.documents,
    required this.dateAjout,
  });

  factory Terrain.creer({
    required String id,
    required String titre,
    required List<Borne> bornes,
    required StatutTerrain statut,
    required double prix,
    required String ville,
    required String quartier,
    required String description,
    required String titreFoncier,
    required String agentId,
    required String agentWhatsapp,
    List<String> photos = const [],
    List<String> documents = const [],
    DateTime? dateAjout,
  }) {
    if (bornes.length < 3) {
      throw const DomainError('Un terrain doit avoir au minimum 3 bornes GPS.');
    }
    if (prix <= 0) {
      throw const DomainError('Le prix doit être positif en XAF.');
    }
    if (titre.trim().isEmpty) {
      throw const DomainError('Le titre du terrain est obligatoire.');
    }

    return Terrain._(
      id: id,
      titre: titre,
      bornes: List.unmodifiable(bornes),
      surfaceM2: SurfaceTerrain.calculerDepuisBornes(bornes),
      statut: statut,
      prix: prix,
      ville: ville,
      quartier: quartier,
      description: description,
      titreFoncier: titreFoncier,
      agentId: agentId,
      agentWhatsapp: agentWhatsapp,
      photos: List.unmodifiable(photos),
      documents: List.unmodifiable(documents),
      dateAjout: dateAjout ?? DateTime.now(),
    );
  }

  Terrain copyWith({
    String? titre,
    List<Borne>? bornes,
    StatutTerrain? statut,
    double? prix,
    String? ville,
    String? quartier,
    String? description,
    String? titreFoncier,
    String? agentId,
    String? agentWhatsapp,
    List<String>? photos,
    List<String>? documents,
  }) {
    final nextBornes = bornes ?? this.bornes;
    if (nextBornes.length < 3) {
      throw const DomainError('Un terrain doit avoir au minimum 3 bornes GPS.');
    }
    final nextPrix = prix ?? this.prix;
    if (nextPrix <= 0) {
      throw const DomainError('Le prix doit être positif en XAF.');
    }
    return Terrain._(
      id: id,
      titre: titre ?? this.titre,
      bornes: List.unmodifiable(nextBornes),
      surfaceM2: SurfaceTerrain.calculerDepuisBornes(nextBornes),
      statut: statut ?? this.statut,
      prix: nextPrix,
      ville: ville ?? this.ville,
      quartier: quartier ?? this.quartier,
      description: description ?? this.description,
      titreFoncier: titreFoncier ?? this.titreFoncier,
      agentId: agentId ?? this.agentId,
      agentWhatsapp: agentWhatsapp ?? this.agentWhatsapp,
      photos: List.unmodifiable(photos ?? this.photos),
      documents: List.unmodifiable(documents ?? this.documents),
      dateAjout: dateAjout,
    );
  }

  Terrain archiver() {
    if (statut == StatutTerrain.archive) {
      throw const DomainError('Ce terrain est déjà archivé.');
    }
    return Terrain._(
      id: id,
      titre: titre,
      bornes: bornes,
      surfaceM2: surfaceM2,
      statut: StatutTerrain.archive,
      prix: prix,
      ville: ville,
      quartier: quartier,
      description: description,
      titreFoncier: titreFoncier,
      agentId: agentId,
      agentWhatsapp: agentWhatsapp,
      photos: photos,
      documents: documents,
      dateAjout: dateAjout,
    );
  }
}
