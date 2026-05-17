import 'package:intl/intl.dart';

import '../../domain/shared/formatage_prix.dart';

class Formatters {
  static String prix(double montant) => FormatagePrix.xaf(montant);

  static String surfaceM2(double m2) {
    if (m2 >= 10000) {
      return '${(m2 / 10000).toStringAsFixed(2)} ha';
    }
    return '${m2.toStringAsFixed(0)} m²';
  }

  static String dateCourt(DateTime d) =>
      DateFormat.yMMMMd('fr_FR').format(d);

  static String gps4(double v) => v.toStringAsFixed(4);
}
