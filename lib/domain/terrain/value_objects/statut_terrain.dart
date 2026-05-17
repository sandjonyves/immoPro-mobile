enum StatutTerrain {
  disponible,
  enNegociation,
  vendu,
  loue,
  travaux,
  archive;

  String get label => switch (this) {
        StatutTerrain.disponible => 'Disponible',
        StatutTerrain.enNegociation => 'En négociation',
        StatutTerrain.vendu => 'Vendu',
        StatutTerrain.loue => 'Loué',
        StatutTerrain.travaux => 'Travaux',
        StatutTerrain.archive => 'Archivé',
      };
}
