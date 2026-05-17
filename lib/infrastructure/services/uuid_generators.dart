import 'package:uuid/uuid.dart';

import '../../domain/audit/use_cases/creer_service_audit.dart';
import '../../domain/maison/use_cases/creer_maison.dart';
import '../../domain/terrain/use_cases/creer_terrain.dart';

class UuidTerrainIds implements IdGenerateurTerrain {
  final _uuid = const Uuid();
  @override
  String nouveau() => 'T-${_uuid.v4()}';
}

class UuidMaisonIds implements IdGenerateurMaison {
  final _uuid = const Uuid();
  @override
  String nouveau() => 'M-${_uuid.v4()}';
}

class UuidAuditIds implements IdGenerateurAudit {
  final _uuid = const Uuid();
  @override
  String nouveau() => 'A-${_uuid.v4()}';
}
