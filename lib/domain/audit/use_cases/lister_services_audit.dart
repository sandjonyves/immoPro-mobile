import '../entities/service_audit.dart';
import '../repositories/i_audit_repository.dart';

class ListerServicesAudit {
  final IAuditRepository _repository;
  const ListerServicesAudit(this._repository);

  Future<List<ServiceAudit>> execute({bool seulementActifs = false}) async {
    final all = await _repository.tous();
    if (!seulementActifs) return all;
    return all.where((s) => s.actif).toList();
  }
}
