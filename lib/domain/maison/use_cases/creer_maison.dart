import '../entities/maison.dart';
import '../repositories/i_maison_repository.dart';
import '../value_objects/localisation.dart';
import '../value_objects/statut_maison.dart';
import '../value_objects/type_maison.dart';

class CreerMaisonInput {
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

  CreerMaisonInput({
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
    this.surfaceTerrainM2,
    required this.agentId,
    required this.agentWhatsapp,
    this.photos = const [],
  });
}

abstract interface class IdGenerateurMaison {
  String nouveau();
}

class CreerMaison {
  final IMaisonRepository _repository;
  final IdGenerateurMaison _ids;

  CreerMaison(this._repository, this._ids);

  Future<Maison> execute(CreerMaisonInput input) async {
    final m = Maison.creer(
      id: _ids.nouveau(),
      titre: input.titre,
      localisation: input.localisation,
      type: input.type,
      statut: input.statut,
      prix: input.prix,
      ville: input.ville,
      quartier: input.quartier,
      description: input.description,
      chambres: input.chambres,
      sallesDeBain: input.sallesDeBain,
      etages: input.etages,
      surfaceHabitableM2: input.surfaceHabitableM2,
      surfaceTerrainM2: input.surfaceTerrainM2,
      agentId: input.agentId,
      agentWhatsapp: input.agentWhatsapp,
      photos: input.photos,
    );
    await _repository.enregistrer(m);
    return m;
  }
}
