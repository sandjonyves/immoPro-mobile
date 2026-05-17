import 'dart:math';

import 'borne.dart';

class SurfaceTerrain {
  final double valeur;

  const SurfaceTerrain._(this.valeur);

  /// Formule de Shoelace projetée (approximation sphère).
  factory SurfaceTerrain.calculerDepuisBornes(List<Borne> bornes) {
    const double r = 6371000.0;
    double area = 0.0;
    final int n = bornes.length;
    for (int i = 0; i < n; i++) {
      final j = (i + 1) % n;
      final xi = bornes[i].longitude *
          pi /
          180 *
          cos(bornes[i].latitude * pi / 180) *
          r;
      final yi = bornes[i].latitude * pi / 180 * r;
      final xj = bornes[j].longitude *
          pi /
          180 *
          cos(bornes[j].latitude * pi / 180) *
          r;
      final yj = bornes[j].latitude * pi / 180 * r;
      area += xi * yj - xj * yi;
    }
    return SurfaceTerrain._((area.abs() / 2.0).roundToDouble());
  }

  String get formate {
    if (valeur >= 10000) {
      return '${(valeur / 10000).toStringAsFixed(2)} ha';
    }
    return '${valeur.toStringAsFixed(0)} m²';
  }
}
