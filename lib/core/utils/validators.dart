/// Validation simple UI — la validation métier reste dans le domaine.
class Validators {
  static String? nonVide(String? v, String label) {
    if (v == null || v.trim().isEmpty) {
      return '$label est obligatoire';
    }
    return null;
  }

  static String? whatsappCm(String? v) {
    if (v == null || v.trim().isEmpty) return 'Numéro obligatoire';
    final s = v.replaceAll(RegExp(r'\s'), '');
    if (!RegExp(r'^237\d{9}$').hasMatch(s)) {
      return 'Format attendu : 237XXXXXXXXX';
    }
    return null;
  }
}
