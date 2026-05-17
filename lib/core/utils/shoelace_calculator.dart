import 'dart:math';

import '../../../domain/terrain/value_objects/borne.dart';

/// Calcul Shoelace géodésique — réutilisable hors widgets.
double shoelaceAreaM2(List<Borne> bornes) {
  const double r = 6371000.0;
  double area = 0.0;
  final int n = bornes.length;
  for (int i = 0; i < n; i++) {
    final j = (i + 1) % n;
    final xi =
        bornes[i].longitude * pi / 180 * cos(bornes[i].latitude * pi / 180) * r;
    final yi = bornes[i].latitude * pi / 180 * r;
    final xj =
        bornes[j].longitude * pi / 180 * cos(bornes[j].latitude * pi / 180) * r;
    final yj = bornes[j].latitude * pi / 180 * r;
    area += xi * yj - xj * yi;
  }
  return (area.abs() / 2.0);
}
