import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/terrain/repositories/i_terrain_repository.dart';
import '../../domain/terrain/use_cases/archiver_terrain.dart';
import '../../domain/terrain/use_cases/creer_terrain.dart';
import '../../domain/terrain/use_cases/lister_terrains.dart';
import '../../domain/terrain/use_cases/modifier_terrain.dart';
import '../../domain/terrain/use_cases/obtenir_terrain.dart';
import '../../domain/terrain/use_cases/rechercher_terrains.dart';
import '../../domain/terrain/use_cases/supprimer_terrain.dart';
import '../../domain/whatsapp/use_cases/contacter_pour_terrain.dart';
import 'terrain_state.dart';

class TerrainCubit extends Cubit<TerrainState> {
  final ListerTerrains _listerTerrains;
  final RechercherTerrains _rechercherTerrains;
  final ObtenirTerrain _obtenirTerrain;
  final CreerTerrain _creerTerrain;
  final ModifierTerrain _modifierTerrain;
  final SupprimerTerrain _supprimerTerrain;
  final ArchiverTerrain _archiverTerrain;
  final ContacterPourTerrain _contacterPourTerrain;

  TerrainCubit({
    required ListerTerrains listerTerrains,
    required RechercherTerrains rechercherTerrains,
    required ObtenirTerrain obtenirTerrain,
    required CreerTerrain creerTerrain,
    required ModifierTerrain modifierTerrain,
    required SupprimerTerrain supprimerTerrain,
    required ArchiverTerrain archiverTerrain,
    required ContacterPourTerrain contacterPourTerrain,
  })  : _listerTerrains = listerTerrains,
        _rechercherTerrains = rechercherTerrains,
        _obtenirTerrain = obtenirTerrain,
        _creerTerrain = creerTerrain,
        _modifierTerrain = modifierTerrain,
        _supprimerTerrain = supprimerTerrain,
        _archiverTerrain = archiverTerrain,
        _contacterPourTerrain = contacterPourTerrain,
        super(const TerrainInitial());

  Future<void> chargerListe() async {
    emit(const TerrainLoading());
    try {
      final terrains = await _listerTerrains.execute();
      emit(TerrainListLoaded(terrains));
    } catch (e) {
      emit(TerrainError(e.toString()));
    }
  }

  Future<void> rechercher(CritereRechercheTerrain criteres) async {
    emit(const TerrainLoading());
    try {
      final terrains = await _rechercherTerrains.execute(criteres);
      emit(TerrainListLoaded(terrains));
    } catch (e) {
      emit(TerrainError(e.toString()));
    }
  }

  Future<void> chargerDetail(String id) async {
    emit(const TerrainLoading());
    try {
      final t = await _obtenirTerrain.execute(id);
      if (t == null) {
        emit(const TerrainError('Terrain introuvable.'));
        return;
      }
      emit(TerrainDetailLoaded(t));
    } catch (e) {
      emit(TerrainError(e.toString()));
    }
  }

  Future<void> creer(CreerTerrainInput input) async {
    emit(const TerrainLoading());
    try {
      await _creerTerrain.execute(input);
      await chargerListe();
    } catch (e) {
      emit(TerrainError(e.toString()));
    }
  }

  Future<void> modifier(ModifierTerrainInput input) async {
    emit(const TerrainLoading());
    try {
      await _modifierTerrain.execute(input);
      await chargerDetail(input.id);
    } catch (e) {
      emit(TerrainError(e.toString()));
    }
  }

  Future<void> supprimer(String id) async {
    try {
      await _supprimerTerrain.execute(id);
      await chargerListe();
    } catch (e) {
      emit(TerrainError(e.toString()));
    }
  }

  Future<void> archiver(String id) async {
    try {
      await _archiverTerrain.execute(id);
      await chargerListe();
    } catch (e) {
      emit(TerrainError(e.toString()));
    }
  }

  Future<void> contacterViaWhatsApp({
    required String terrainId,
    required String? nomClient,
  }) async {
    try {
      await _contacterPourTerrain.execute(
        terrainId: terrainId,
        nomClient: nomClient,
      );
    } catch (e) {
      emit(TerrainError(e.toString()));
    }
  }
}
