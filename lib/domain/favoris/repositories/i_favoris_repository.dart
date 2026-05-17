abstract interface class IFavorisRepository {
  Future<Set<String>> terrainsFavoris();
  Future<Set<String>> maisonsFavoris();
  Future<void> basculerTerrain(String id);
  Future<void> basculerMaison(String id);
}
