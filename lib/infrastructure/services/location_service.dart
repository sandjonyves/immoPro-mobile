import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/location/ports/lecteur_position.dart';
import '../../domain/location/value_objects/position_gps.dart';

class LocationService implements LecteurPosition {
  @override
  Future<PositionGps> obtenirPositionActuelle() async {
    final perm = await Permission.locationWhenInUse.request();
    if (!perm.isGranted) {
      throw Exception('Permission de localisation refusée.');
    }
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw Exception('Services de localisation désactivés.');
    }
    final pos = await Geolocator.getCurrentPosition();
    return PositionGps(latitude: pos.latitude, longitude: pos.longitude);
  }
}
