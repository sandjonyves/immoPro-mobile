import '../../shared/formatage_prix.dart';

class TarifAudit {
  final double? minimum;
  final double? maximum;
  final bool surDevis;

  const TarifAudit({
    this.minimum,
    this.maximum,
    this.surDevis = false,
  });

  String get affichage {
    if (surDevis) return 'Sur devis';
    if (minimum != null && maximum != null) {
      return '${FormatagePrix.xaf(minimum!)} — ${FormatagePrix.xaf(maximum!)}';
    }
    if (minimum != null) {
      return 'À partir de ${FormatagePrix.xaf(minimum!)}';
    }
    return 'Sur devis';
  }
}
