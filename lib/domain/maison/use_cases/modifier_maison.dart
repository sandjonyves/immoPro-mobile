import '../../shared/errors/domain_error.dart';
import '../repositories/i_maison_repository.dart';
import '../value_objects/localisation.dart';
import '../value_objects/statut_maison.dart';
import '../value_objects/type_maison.dart';

class ModifierMaisonInput {
  final String id;
  final String? titre;
  final Localisation? localisation;
  final TypeMaison? type;
  final StatutMaison? statut;
  final double? prix;
  final String? ville;
  final String? quartier;
  final String? description;
  final int? chambres;
  final int? sallesDeBain;
  final int? etages;
  final double? surfaceHabitableM2;
  final double? surfaceTerrainM2;
  final String? agentWhatsapp;
  final List<String>? photos;

  const ModifierMaisonInput({
    required this.id,
    this.titre,
    this.localisation,
    this.type,
    this.statut,
    this.prix,
    this.ville,
    this.quartier,
    this.description,
    this.chambres,
    this.sallesDeBain,
    this.etages,
    this.surfaceHabitableM2,
    this.surfaceTerrainM2,
    this.agentWhatsapp,
    this.photos,
  });
}

class ModifierMaison {
  final IMaisonRepository _repository;
  const ModifierMaison(this._repository);

  Future<void> execute(ModifierMaisonInput input) async {
    final existing = await _repository.parId(input.id);
    if (existing == null) {
      throw const DomainError('Maison introuvable.');
    }
    await _repository.enregistrer(
      existing.copyWith(
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
        agentWhatsapp: input.agentWhatsapp,
        photos: input.photos,
      ),
    );
  }
}
