import '../ports/lecteur_position.dart';
import '../value_objects/position_gps.dart';

class ObtenirPositionActuelle {
  final LecteurPosition _lecteur;
  const ObtenirPositionActuelle(this._lecteur);

  Future<PositionGps> execute() => _lecteur.obtenirPositionActuelle();
}
