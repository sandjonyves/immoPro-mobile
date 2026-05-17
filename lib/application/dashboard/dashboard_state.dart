import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  final int biensTotal;
  final int biensDisponibles;
  final int servicesAuditActifs;
  final int utilisateurs;

  const DashboardState({
    required this.biensTotal,
    required this.biensDisponibles,
    required this.servicesAuditActifs,
    required this.utilisateurs,
  });

  @override
  List<Object?> get props =>
      [biensTotal, biensDisponibles, servicesAuditActifs, utilisateurs];
}
