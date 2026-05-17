enum TypeMaison {
  villa,
  appartement,
  duplex,
  studio,
  bureau;

  String get label => switch (this) {
        TypeMaison.villa => 'Villa',
        TypeMaison.appartement => 'Appartement',
        TypeMaison.duplex => 'Duplex',
        TypeMaison.studio => 'Studio',
        TypeMaison.bureau => 'Bureau',
      };
}
