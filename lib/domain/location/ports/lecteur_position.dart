import '../value_objects/position_gps.dart';

/// Port pour la géolocalisation (sans dépendance Flutter dans le domaine).
abstract interface class LecteurPosition {
  Future<PositionGps> obtenirPositionActuelle();
}
