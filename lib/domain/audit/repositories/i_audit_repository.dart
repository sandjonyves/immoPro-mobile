import '../entities/service_audit.dart';

abstract interface class IAuditRepository {
  Future<List<ServiceAudit>> tous();
  Future<ServiceAudit?> parId(String id);
  Future<void> enregistrer(ServiceAudit service);
}
