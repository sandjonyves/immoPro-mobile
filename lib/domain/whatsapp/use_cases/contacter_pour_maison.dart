import '../../maison/repositories/i_maison_repository.dart';
import '../../shared/errors/domain_error.dart';
import '../ports/lanceur_whatsapp.dart';
import '../value_objects/whatsapp_message.dart';

class ContacterPourMaison {
  final LanceurWhatsapp _launcher;
  final IMaisonRepository _maisonRepository;

  const ContacterPourMaison(this._launcher, this._maisonRepository);

  Future<void> execute({
    required String maisonId,
    required String? nomClient,
  }) async {
    final maison = await _maisonRepository.parId(maisonId);
    if (maison == null) {
      throw const DomainError('Maison introuvable.');
    }

    final message = WhatsappMessage.pourMaison(
      maison: maison,
      nomClient: nomClient,
    );

    await _launcher.ouvrirUrl(message.url);
  }
}
