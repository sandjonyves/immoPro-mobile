import 'package:equatable/equatable.dart';

import '../../domain/audit/entities/service_audit.dart';
import '../../domain/audit/value_objects/categorie_audit.dart';

sealed class AuditState extends Equatable {
  const AuditState();
  @override
  List<Object?> get props => [];
}

class AuditInitial extends AuditState {
  const AuditInitial();
}

class AuditLoading extends AuditState {
  const AuditLoading();
}

class AuditListLoaded extends AuditState {
  final List<ServiceAudit> services;
  final CategorieAudit? filtre;
  const AuditListLoaded(this.services, {this.filtre});

  @override
  List<Object?> get props => [services, filtre];
}

class AuditDetailLoaded extends AuditState {
  final ServiceAudit service;
  const AuditDetailLoaded(this.service);
  @override
  List<Object?> get props => [service];
}

class AuditError extends AuditState {
  final String message;
  const AuditError(this.message);
  @override
  List<Object?> get props => [message];
}
