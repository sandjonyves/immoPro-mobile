import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/utilisateur/repositories/i_utilisateur_repository.dart';
import '../../domain/utilisateur/use_cases/modifier_utilisateur.dart';
import '../../domain/utilisateur/use_cases/supprimer_utilisateur.dart';
import '../../domain/utilisateur/value_objects/role.dart';
import 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final IUtilisateurRepository _repository;
  final ModifierUtilisateur _modifier;
  final SupprimerUtilisateur _supprimer;

  UsersCubit({
    required IUtilisateurRepository repository,
    required ModifierUtilisateur modifier,
    required SupprimerUtilisateur supprimer,
  })  : _repository = repository,
        _modifier = modifier,
        _supprimer = supprimer,
        super(const UsersState(utilisateurs: []));

  Future<void> charger({Role? filtre}) async {
    final all = await _repository.tous();
    final list = filtre == null
        ? all
        : all.where((u) => u.role == filtre).toList();
    emit(UsersState(utilisateurs: list, filtreRole: filtre));
  }

  Future<void> modifierRole({
    required String id,
    required Role role,
  }) async {
    await _modifier.execute(ModifierUtilisateurInput(id: id, role: role));
    await charger(filtre: state.filtreRole);
  }

  Future<void> supprimerUser(String id) async {
    await _supprimer.execute(id);
    await charger(filtre: state.filtreRole);
  }
}
