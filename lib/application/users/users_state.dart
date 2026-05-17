import 'package:equatable/equatable.dart';

import '../../domain/utilisateur/entities/utilisateur.dart';
import '../../domain/utilisateur/value_objects/role.dart';

class UsersState extends Equatable {
  final List<Utilisateur> utilisateurs;
  final Role? filtreRole;

  const UsersState({
    required this.utilisateurs,
    this.filtreRole,
  });

  @override
  List<Object?> get props => [utilisateurs, filtreRole];
}
