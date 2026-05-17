import '../../domain/terrain/entities/terrain.dart';
import '../../domain/terrain/repositories/i_terrain_repository.dart';
import '../mock_data/terrains_mock.dart';

class InMemoryTerrainRepository implements ITerrainRepository {
  final List<Terrain> _items = List.of(terrainsMock);

  @override
  Future<void> enregistrer(Terrain terrain) async {
    final i = _items.indexWhere((t) => t.id == terrain.id);
    if (i >= 0) {
      _items[i] = terrain;
    } else {
      _items.add(terrain);
    }
  }

  @override
  Future<Terrain?> parId(String id) async {
    try {
      return _items.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> supprimer(String id) async {
    _items.removeWhere((t) => t.id == id);
  }

  @override
  Future<List<Terrain>> tous() async => List.unmodifiable(_items);
}
