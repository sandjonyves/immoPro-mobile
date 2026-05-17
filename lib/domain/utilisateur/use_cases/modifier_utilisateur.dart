import '../../shared/errors/domain_error.dart';
import '../repositories/i_utilisateur_repository.dart';
import '../value_objects/role.dart';
import '../value_objects/statut_utilisateur.dart';

class ModifierUtilisateurInput {
  final String id;
  final Role? role;
  final StatutUtilisateur? statut;
  final String? nom;
  final String? telephone;

  const ModifierUtilisateurInput({
    required this.id,
    this.role,
    this.statut,
    this.nom,
    this.telephone,
  });
}

class ModifierUtilisateur {
  final IUtilisateurRepository _repository;
  const ModifierUtilisateur(this._repository);

  Future<void> execute(ModifierUtilisateurInput input) async {
    final existing = await _repository.parId(input.id);
    if (existing == null) {
      throw const DomainError('Utilisateur introuvable.');
    }
    await _repository.enregistrer(
      existing.copyWith(
        role: input.role,
        statut: input.statut,
        nom: input.nom,
        telephone: input.telephone,
      ),
    );
  }
}
