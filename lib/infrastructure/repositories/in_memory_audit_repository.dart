import '../../domain/audit/entities/service_audit.dart';
import '../../domain/audit/repositories/i_audit_repository.dart';
import '../mock_data/audits_mock.dart';

class InMemoryAuditRepository implements IAuditRepository {
  final List<ServiceAudit> _items = List.of(auditsMock);

  @override
  Future<void> enregistrer(ServiceAudit service) async {
    final i = _items.indexWhere((s) => s.id == service.id);
    if (i >= 0) {
      _items[i] = service;
    } else {
      _items.add(service);
    }
  }

  @override
  Future<ServiceAudit?> parId(String id) async {
    try {
      return _items.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ServiceAudit>> tous() async => List.unmodifiable(_items);
}
