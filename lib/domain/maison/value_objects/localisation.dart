class Localisation {
  final double latitude;
  final double longitude;

  const Localisation._({required this.latitude, required this.longitude});

  factory Localisation(double latitude, double longitude) {
    if (latitude < -90 || latitude > 90) {
      throw ArgumentError('Latitude invalide.');
    }
    if (longitude < -180 || longitude > 180) {
      throw ArgumentError('Longitude invalide.');
    }
    return Localisation._(latitude: latitude, longitude: longitude);
  }
}
