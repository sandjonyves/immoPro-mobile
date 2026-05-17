import '../../shared/errors/domain_error.dart';
import '../value_objects/localisation.dart';
import '../value_objects/statut_maison.dart';
import '../value_objects/type_maison.dart';

class Maison {
  final String id;
  final String titre;
  final Localisation localisation;
  final TypeMaison type;
  final StatutMaison statut;
  final double prix;
  final String ville;
  final String quartier;
  final String description;
  final int chambres;
  final int sallesDeBain;
  final int etages;
  final double surfaceHabitableM2;
  final double? surfaceTerrainM2;
  final String agentId;
  final String agentWhatsapp;
  final List<String> photos;
  final DateTime dateAjout;

  const Maison._({
    required this.id,
    required this.titre,
    required this.localisation,
    required this.type,
    required this.statut,
    required this.prix,
    required this.ville,
    required this.quartier,
    required this.description,
    required this.chambres,
    required this.sallesDeBain,
    required this.etages,
    required this.surfaceHabitableM2,
    required this.surfaceTerrainM2,
    required this.agentId,
    required this.agentWhatsapp,
    required this.photos,
    required this.dateAjout,
  });

  factory Maison.creer({
    required String id,
    required String titre,
    required Localisation localisation,
    required TypeMaison type,
    required StatutMaison statut,
    required double prix,
    required String ville,
    required String quartier,
    required String description,
    required int chambres,
    required int sallesDeBain,
    required int etages,
    required double surfaceHabitableM2,
    double? surfaceTerrainM2,
    required String agentId,
    required String agentWhatsapp,
    List<String> photos = const [],
    DateTime? dateAjout,
  }) {
    if (titre.trim().isEmpty) {
      throw const DomainError('Le titre est obligatoire.');
    }
    if (prix <= 0) {
      throw const DomainError('Le prix doit être positif en XAF.');
    }
    if (surfaceHabitableM2 <= 0) {
      throw const DomainError('La surface habitable doit être positive.');
    }
    if (chambres < 0 || sallesDeBain < 0 || etages < 0) {
      throw const DomainError('Les caractéristiques du bien sont invalides.');
    }

    return Maison._(
      id: id,
      titre: titre,
      localisation: localisation,
      type: type,
      statut: statut,
      prix: prix,
      ville: ville,
      quartier: quartier,
      description: description,
      chambres: chambres,
      sallesDeBain: sallesDeBain,
      etages: etages,
      surfaceHabitableM2: surfaceHabitableM2,
      surfaceTerrainM2: surfaceTerrainM2,
      agentId: agentId,
      agentWhatsapp: agentWhatsapp,
      photos: List.unmodifiable(photos),
      dateAjout: dateAjout ?? DateTime.now(),
    );
  }

  Maison copyWith({
    String? titre,
    Localisation? localisation,
    TypeMaison? type,
    StatutMaison? statut,
    double? prix,
    String? ville,
    String? quartier,
    String? description,
    int? chambres,
    int? sallesDeBain,
    int? etages,
    double? surfaceHabitableM2,
    double? surfaceTerrainM2,
    String? agentWhatsapp,
    List<String>? photos,
  }) {
    return Maison._(
      id: id,
      titre: titre ?? this.titre,
      localisation: localisation ?? this.localisation,
      type: type ?? this.type,
      statut: statut ?? this.statut,
      prix: prix ?? this.prix,
      ville: ville ?? this.ville,
      quartier: quartier ?? this.quartier,
      description: description ?? this.description,
      chambres: chambres ?? this.chambres,
      sallesDeBain: sallesDeBain ?? this.sallesDeBain,
      etages: etages ?? this.etages,
      surfaceHabitableM2: surfaceHabitableM2 ?? this.surfaceHabitableM2,
      surfaceTerrainM2: surfaceTerrainM2 ?? this.surfaceTerrainM2,
      agentId: agentId,
      agentWhatsapp: agentWhatsapp ?? this.agentWhatsapp,
      photos: List.unmodifiable(photos ?? this.photos),
      dateAjout: dateAjout,
    );
  }
}
