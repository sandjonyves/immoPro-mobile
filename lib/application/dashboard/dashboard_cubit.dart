import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/audit/use_cases/lister_services_audit.dart';
import '../../domain/maison/use_cases/lister_maisons.dart';
import '../../domain/maison/value_objects/statut_maison.dart';
import '../../domain/terrain/use_cases/lister_terrains.dart';
import '../../domain/terrain/value_objects/statut_terrain.dart';
import '../../domain/utilisateur/repositories/i_utilisateur_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState?> {
  final ListerTerrains _terrains;
  final ListerMaisons _maisons;
  final ListerServicesAudit _audits;
  final IUtilisateurRepository _users;

  DashboardCubit({
    required ListerTerrains terrains,
    required ListerMaisons maisons,
    required ListerServicesAudit audits,
    required IUtilisateurRepository users,
  })  : _terrains = terrains,
        _maisons = maisons,
        _audits = audits,
        _users = users,
        super(null);

  Future<void> charger() async {
    final t = await _terrains.execute();
    final m = await _maisons.execute();
    final a = await _audits.execute(seulementActifs: false);
    final u = await _users.tous();

    final dispo = t
            .where((x) =>
                x.statut == StatutTerrain.disponible ||
                x.statut == StatutTerrain.enNegociation)
            .length +
        m
            .where((x) =>
                x.statut == StatutMaison.disponible ||
                x.statut == StatutMaison.enNegociation)
            .length;

    emit(DashboardState(
      biensTotal: t.length + m.length,
      biensDisponibles: dispo,
      servicesAuditActifs: a.where((s) => s.actif).length,
      utilisateurs: u.length,
    ));
  }
}
