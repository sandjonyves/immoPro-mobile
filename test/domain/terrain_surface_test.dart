import 'package:flutter_test/flutter_test.dart';

import 'package:immopro/domain/shared/errors/domain_error.dart';
import 'package:immopro/domain/terrain/value_objects/borne.dart';
import 'package:immopro/domain/terrain/value_objects/statut_terrain.dart';
import 'package:immopro/domain/terrain/value_objects/surface_terrain.dart';
import 'package:immopro/domain/terrain/entities/terrain.dart';

void main() {
  group('Borne', () {
    test('rejette latitude hors plage', () {
      expect(() => Borne(100, 10), throwsArgumentError);
    });
  });

  group('SurfaceTerrain', () {
    test('calcule une surface positive pour un triangle', () {
      final bornes = [
        Borne(0, 0),
        Borne(0, 0.01),
        Borne(0.01, 0),
      ];
      final s = SurfaceTerrain.calculerDepuisBornes(bornes);
      expect(s.valeur, greaterThan(0));
    });
  });

  group('Terrain.creer', () {
    test('exige au moins 3 bornes', () {
      expect(
        () => Terrain.creer(
          id: 'x',
          titre: 't',
          bornes: [Borne(1, 2), Borne(3, 4)],
          statut: StatutTerrain.disponible,
          prix: 1000,
          ville: 'Yaoundé',
          quartier: 'Centre',
          description: 'd',
          titreFoncier: 'tf',
          agentId: 'a',
          agentWhatsapp: '237699000001',
        ),
        throwsA(isA<DomainError>()),
      );
    });
  });
}
