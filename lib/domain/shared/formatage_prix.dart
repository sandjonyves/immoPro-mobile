import 'package:intl/intl.dart';

/// Formatage numéraire pur Dart (utilisable depuis le domaine).
abstract final class FormatagePrix {
  static String xaf(double montant) {
    final f = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: '',
      decimalDigits: 0,
    );
    return '${f.format(montant).replaceAll('\u00a0', ' ').trim()} XAF';
  }
}
