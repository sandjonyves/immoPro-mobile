/// Port domaine — implémenté dans l’infrastructure (`url_launcher`).
abstract interface class LanceurWhatsapp {
  Future<void> ouvrirUrl(String url);
}
