import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/audit/entities/service_audit.dart';
import '../../domain/audit/use_cases/creer_service_audit.dart';
import '../../domain/audit/use_cases/lister_services_audit.dart';
import '../../domain/audit/use_cases/modifier_service_audit.dart';
import '../../domain/audit/use_cases/obtenir_service_audit.dart';
import '../../domain/audit/value_objects/categorie_audit.dart';
import '../../domain/whatsapp/use_cases/contacter_pour_audit.dart';
import 'audit_state.dart';

class AuditCubit extends Cubit<AuditState> {
  final ListerServicesAudit _lister;
  final ObtenirServiceAudit _obtenir;
  final ModifierServiceAudit _modifier;
  final CreerServiceAudit _creer;
  final ContacterPourAudit _contacter;

  List<ServiceAudit> _catalogueComplet = [];

  AuditCubit({
    required ListerServicesAudit lister,
    required ObtenirServiceAudit obtenir,
    required ModifierServiceAudit modifier,
    required CreerServiceAudit creer,
    required ContacterPourAudit contacter,
  })  : _lister = lister,
        _obtenir = obtenir,
        _modifier = modifier,
        _creer = creer,
        _contacter = contacter,
        super(const AuditInitial());

  Future<void> charger({bool actifsSeulement = true}) async {
    emit(const AuditLoading());
    try {
      final services = await _lister.execute(seulementActifs: actifsSeulement);
      _catalogueComplet = List.of(services);
      emit(AuditListLoaded(services));
    } catch (e) {
      emit(AuditError(e.toString()));
    }
  }

  Future<void> chargerAdmin() async {
    emit(const AuditLoading());
    try {
      final services = await _lister.execute(seulementActifs: false);
      _catalogueComplet = List.of(services);
      emit(AuditListLoaded(services));
    } catch (e) {
      emit(AuditError(e.toString()));
    }
  }

  void appliquerFiltre(CategorieAudit? categorie) {
    if (_catalogueComplet.isEmpty) return;
    final filtered = categorie == null
        ? List<ServiceAudit>.of(_catalogueComplet)
        : _catalogueComplet.where((x) => x.categorie == categorie).toList();
    emit(AuditListLoaded(filtered, filtre: categorie));
  }

  Future<void> chargerDetail(String id) async {
    emit(const AuditLoading());
    try {
      final service = await _obtenir.execute(id);
      if (service == null) {
        emit(const AuditError('Service introuvable.'));
        return;
      }
      emit(AuditDetailLoaded(service));
    } catch (e) {
      emit(AuditError(e.toString()));
    }
  }

  Future<void> modifierService(ModifierServiceAuditInput input) async {
    emit(const AuditLoading());
    try {
      await _modifier.execute(input);
      await chargerAdmin();
    } catch (e) {
      emit(AuditError(e.toString()));
    }
  }

  Future<void> creerService(CreerServiceAuditInput input) async {
    emit(const AuditLoading());
    try {
      await _creer.execute(input);
      await chargerAdmin();
    } catch (e) {
      emit(AuditError(e.toString()));
    }
  }

  Future<void> contacterViaWhatsApp({
    required String serviceId,
    required String? nomClient,
    required String? descriptionBien,
  }) async {
    try {
      await _contacter.execute(
        serviceId: serviceId,
        nomClient: nomClient,
        descriptionBien: descriptionBien,
      );
    } catch (e) {
      emit(AuditError(e.toString()));
    }
  }
}
