import 'package:get_it/get_it.dart';

import '../../application/audit/audit_cubit.dart';
import '../../application/auth/auth_cubit.dart';
import '../../application/dashboard/dashboard_cubit.dart';
import '../../application/favoris/favoris_cubit.dart';
import '../../application/maison/maison_cubit.dart';
import '../../application/terrain/terrain_cubit.dart';
import '../../application/theme/theme_cubit.dart';
import '../../application/users/users_cubit.dart';
import '../../domain/audit/repositories/i_audit_repository.dart';
import '../../domain/audit/use_cases/creer_service_audit.dart'
    show CreerServiceAudit, IdGenerateurAudit;
import '../../domain/audit/use_cases/lister_services_audit.dart';
import '../../domain/audit/use_cases/modifier_service_audit.dart';
import '../../domain/audit/use_cases/obtenir_service_audit.dart';
import '../../domain/favoris/repositories/i_favoris_repository.dart';
import '../../domain/favoris/use_cases/basculer_favori_maison.dart';
import '../../domain/favoris/use_cases/basculer_favori_terrain.dart';
import '../../domain/favoris/use_cases/obtenir_favoris.dart';
import '../../domain/location/ports/lecteur_position.dart';
import '../../domain/location/use_cases/obtenir_position_actuelle.dart';
import '../../domain/maison/repositories/i_maison_repository.dart';
import '../../domain/maison/use_cases/creer_maison.dart'
    show CreerMaison, IdGenerateurMaison;
import '../../domain/maison/use_cases/lister_maisons.dart';
import '../../domain/maison/use_cases/modifier_maison.dart';
import '../../domain/maison/use_cases/obtenir_maison.dart';
import '../../domain/maison/use_cases/rechercher_maisons.dart';
import '../../domain/maison/use_cases/supprimer_maison.dart';
import '../../domain/terrain/repositories/i_terrain_repository.dart';
import '../../domain/terrain/use_cases/archiver_terrain.dart';
import '../../domain/terrain/use_cases/creer_terrain.dart'
    show CreerTerrain, IdGenerateurTerrain;
import '../../domain/terrain/use_cases/lister_terrains.dart';
import '../../domain/terrain/use_cases/modifier_terrain.dart';
import '../../domain/terrain/use_cases/obtenir_terrain.dart';
import '../../domain/terrain/use_cases/rechercher_terrains.dart';
import '../../domain/terrain/use_cases/supprimer_terrain.dart';
import '../../domain/utilisateur/repositories/i_utilisateur_repository.dart';
import '../../domain/utilisateur/use_cases/modifier_utilisateur.dart';
import '../../domain/utilisateur/use_cases/obtenir_profil.dart';
import '../../domain/utilisateur/use_cases/se_connecter.dart';
import '../../domain/utilisateur/use_cases/se_deconnecter.dart';
import '../../domain/utilisateur/use_cases/supprimer_utilisateur.dart';
import '../../domain/whatsapp/ports/lanceur_whatsapp.dart';
import '../../domain/whatsapp/use_cases/contacter_pour_audit.dart';
import '../../domain/whatsapp/use_cases/contacter_pour_maison.dart';
import '../../domain/whatsapp/use_cases/contacter_pour_terrain.dart';
import '../../infrastructure/repositories/in_memory_audit_repository.dart';
import '../../infrastructure/repositories/in_memory_maison_repository.dart';
import '../../infrastructure/repositories/in_memory_terrain_repository.dart';
import '../../infrastructure/repositories/in_memory_utilisateur_repository.dart';
import '../../infrastructure/repositories/shared_prefs_favoris_repository.dart';
import '../../infrastructure/services/location_service.dart';
import '../../infrastructure/services/session_storage.dart';
import '../../infrastructure/services/uuid_generators.dart';
import '../../infrastructure/services/whatsapp_service.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl
    ..registerLazySingleton<ITerrainRepository>(
      () => InMemoryTerrainRepository(),
    )
    ..registerLazySingleton<IMaisonRepository>(
      () => InMemoryMaisonRepository(),
    )
    ..registerLazySingleton<IAuditRepository>(
      () => InMemoryAuditRepository(),
    )
    ..registerLazySingleton<IUtilisateurRepository>(
      () => InMemoryUtilisateurRepository(),
    )
    ..registerLazySingleton<IFavorisRepository>(
      () => SharedPrefsFavorisRepository(),
    )
    ..registerLazySingleton<LanceurWhatsapp>(
      () => WhatsappService(),
    )
    ..registerLazySingleton<LecteurPosition>(
      () => LocationService(),
    )
    ..registerLazySingleton<SessionStorage>(
      () => SessionStorage(),
    )
    ..registerLazySingleton<IdGenerateurTerrain>(
      () => UuidTerrainIds(),
    )
    ..registerLazySingleton<IdGenerateurMaison>(
      () => UuidMaisonIds(),
    )
    ..registerLazySingleton<IdGenerateurAudit>(
      () => UuidAuditIds(),
    );

  sl
    ..registerLazySingleton(() => ListerTerrains(sl()))
    ..registerLazySingleton(() => RechercherTerrains(sl()))
    ..registerLazySingleton(() => ObtenirTerrain(sl()))
    ..registerLazySingleton(() => CreerTerrain(sl(), sl()))
    ..registerLazySingleton(() => ModifierTerrain(sl()))
    ..registerLazySingleton(() => SupprimerTerrain(sl()))
    ..registerLazySingleton(() => ArchiverTerrain(sl()))
    ..registerLazySingleton(() => ContacterPourTerrain(sl(), sl()));

  sl
    ..registerLazySingleton(() => ListerMaisons(sl()))
    ..registerLazySingleton(() => RechercherMaisons(sl()))
    ..registerLazySingleton(() => ObtenirMaison(sl()))
    ..registerLazySingleton(() => CreerMaison(sl(), sl()))
    ..registerLazySingleton(() => ModifierMaison(sl()))
    ..registerLazySingleton(() => SupprimerMaison(sl()))
    ..registerLazySingleton(() => ContacterPourMaison(sl(), sl()));

  sl
    ..registerLazySingleton(() => ListerServicesAudit(sl()))
    ..registerLazySingleton(() => ObtenirServiceAudit(sl()))
    ..registerLazySingleton(() => ModifierServiceAudit(sl()))
    ..registerLazySingleton(() => CreerServiceAudit(sl(), sl()))
    ..registerLazySingleton(() => ContacterPourAudit(sl(), sl()));

  sl
    ..registerLazySingleton(() => SeConnecter(sl()))
    ..registerLazySingleton(() => const SeDeconnecter())
    ..registerLazySingleton(() => ObtenirProfil(sl()))
    ..registerLazySingleton(() => ModifierUtilisateur(sl()))
    ..registerLazySingleton(() => SupprimerUtilisateur(sl()));

  sl
    ..registerLazySingleton(() => ObtenirFavoris(sl()))
    ..registerLazySingleton(() => BasculerFavoriTerrain(sl()))
    ..registerLazySingleton(() => BasculerFavoriMaison(sl()));

  sl.registerLazySingleton(() => ObtenirPositionActuelle(sl()));

  sl.registerLazySingleton(
    () => AuthCubit(
      seConnecter: sl(),
      seDeconnecter: sl(),
      obtenirProfil: sl(),
      session: sl(),
    ),
  );

  sl.registerLazySingleton(ThemeCubit.new);

  sl.registerLazySingleton(
    () => TerrainCubit(
      listerTerrains: sl(),
      rechercherTerrains: sl(),
      obtenirTerrain: sl(),
      creerTerrain: sl(),
      modifierTerrain: sl(),
      supprimerTerrain: sl(),
      archiverTerrain: sl(),
      contacterPourTerrain: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => MaisonCubit(
      listerMaisons: sl(),
      rechercherMaisons: sl(),
      obtenirMaison: sl(),
      creerMaison: sl(),
      modifierMaison: sl(),
      supprimerMaison: sl(),
      contacterPourMaison: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => AuditCubit(
      lister: sl(),
      obtenir: sl(),
      modifier: sl(),
      creer: sl(),
      contacter: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => FavorisCubit(
      obtenir: sl(),
      basculerTerrain: sl(),
      basculerMaison: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => DashboardCubit(
      terrains: sl(),
      maisons: sl(),
      audits: sl(),
      users: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => UsersCubit(
      repository: sl(),
      modifier: sl(),
      supprimer: sl(),
    ),
  );
}
