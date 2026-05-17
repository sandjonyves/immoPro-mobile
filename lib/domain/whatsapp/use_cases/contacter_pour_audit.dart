import '../../audit/repositories/i_audit_repository.dart';
import '../../shared/errors/domain_error.dart';
import '../ports/lanceur_whatsapp.dart';
import '../value_objects/whatsapp_message.dart';

class ContacterPourAudit {
  final LanceurWhatsapp _launcher;
  final IAuditRepository _auditRepository;

  const ContacterPourAudit(this._launcher, this._auditRepository);

  Future<void> execute({
    required String serviceId,
    required String? nomClient,
    required String? descriptionBien,
  }) async {
    final service = await _auditRepository.parId(serviceId);
    if (service == null) {
      throw const DomainError('Service d\'audit introuvable.');
    }

    final message = WhatsappMessage.pourAudit(
      service: service,
      nomClient: nomClient,
      descriptionBien: descriptionBien,
    );

    await _launcher.ouvrirUrl(message.url);
  }
}
