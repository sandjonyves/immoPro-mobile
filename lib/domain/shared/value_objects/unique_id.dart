class UniqueId {
  final String valeur;
  const UniqueId(this.valeur);

  @override
  bool operator ==(Object other) =>
      other is UniqueId && other.valeur == valeur;

  @override
  int get hashCode => valeur.hashCode;
}
