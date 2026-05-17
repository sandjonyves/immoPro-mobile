import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/favoris/use_cases/basculer_favori_maison.dart';
import '../../domain/favoris/use_cases/basculer_favori_terrain.dart';
import '../../domain/favoris/use_cases/obtenir_favoris.dart';
import 'favoris_state.dart';

class FavorisCubit extends Cubit<FavorisState> {
  final ObtenirFavoris _obtenir;
  final BasculerFavoriTerrain _basculerTerrain;
  final BasculerFavoriMaison _basculerMaison;

  FavorisCubit({
    required ObtenirFavoris obtenir,
    required BasculerFavoriTerrain basculerTerrain,
    required BasculerFavoriMaison basculerMaison,
  })  : _obtenir = obtenir,
        _basculerTerrain = basculerTerrain,
        _basculerMaison = basculerMaison,
        super(const FavorisState(terrains: {}, maisons: {}));

  Future<void> charger() async {
    final r = await _obtenir.execute();
    emit(FavorisState(terrains: r.terrains, maisons: r.maisons));
  }

  Future<void> basculerTerrain(String id) async {
    await _basculerTerrain.execute(id);
    await charger();
  }

  Future<void> basculerMaison(String id) async {
    await _basculerMaison.execute(id);
    await charger();
  }

  bool terrainEstFavori(String id) => state.terrains.contains(id);
  bool maisonEstFavori(String id) => state.maisons.contains(id);
}
