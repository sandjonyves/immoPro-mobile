class Borne {
  final double latitude;
  final double longitude;

  const Borne._({required this.latitude, required this.longitude});

  factory Borne(double latitude, double longitude) {
    if (latitude < -90 || latitude > 90) {
      throw ArgumentError('Latitude invalide : valeur entre -90 et 90.');
    }
    if (longitude < -180 || longitude > 180) {
      throw ArgumentError('Longitude invalide : valeur entre -180 et 180.');
    }
    return Borne._(latitude: latitude, longitude: longitude);
  }

  @override
  bool operator ==(Object other) =>
      other is Borne &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);
}
