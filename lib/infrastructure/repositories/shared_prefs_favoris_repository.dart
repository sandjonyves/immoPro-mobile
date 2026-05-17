import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/favoris/repositories/i_favoris_repository.dart';

class SharedPrefsFavorisRepository implements IFavorisRepository {
  static const _kTerrains = 'immopro_fav_terrains';
  static const _kMaisons = 'immopro_fav_maisons';

  Future<SharedPreferences> get _p async =>
      SharedPreferences.getInstance();

  Future<Set<String>> _load(String key) async {
    final prefs = await _p;
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return {};
    final list = (jsonDecode(raw) as List<dynamic>).cast<String>();
    return list.toSet();
  }

  Future<void> _save(String key, Set<String> ids) async {
    final prefs = await _p;
    await prefs.setString(key, jsonEncode(ids.toList()));
  }

  @override
  Future<void> basculerMaison(String id) async {
    final set = await maisonsFavoris();
    if (set.contains(id)) {
      set.remove(id);
    } else {
      set.add(id);
    }
    await _save(_kMaisons, set);
  }

  @override
  Future<void> basculerTerrain(String id) async {
    final set = await terrainsFavoris();
    if (set.contains(id)) {
      set.remove(id);
    } else {
      set.add(id);
    }
    await _save(_kTerrains, set);
  }

  @override
  Future<Set<String>> maisonsFavoris() => _load(_kMaisons);

  @override
  Future<Set<String>> terrainsFavoris() => _load(_kTerrains);
}
