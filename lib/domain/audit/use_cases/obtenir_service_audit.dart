import '../entities/service_audit.dart';
import '../repositories/i_audit_repository.dart';

class ObtenirServiceAudit {
  final IAuditRepository _repository;
  const ObtenirServiceAudit(this._repository);

  Future<ServiceAudit?> execute(String id) => _repository.parId(id);
}
