enum StatutMaison {
  disponible,
  enNegociation,
  vendu,
  loue,
  travaux;

  String get label => switch (this) {
        StatutMaison.disponible => 'Disponible',
        StatutMaison.enNegociation => 'En négociation',
        StatutMaison.vendu => 'Vendu',
        StatutMaison.loue => 'Loué',
        StatutMaison.travaux => 'Travaux',
      };
}
