enum StatutUtilisateur {
  actif,
  suspendu;

  String get label => switch (this) {
        StatutUtilisateur.actif => 'Actif',
        StatutUtilisateur.suspendu => 'Suspendu',
      };
}
