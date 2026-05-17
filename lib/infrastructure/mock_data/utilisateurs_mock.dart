import '../../domain/utilisateur/entities/utilisateur.dart';
import '../../domain/utilisateur/value_objects/role.dart';
import '../../domain/utilisateur/value_objects/statut_utilisateur.dart';

final utilisateursMock = [
  Utilisateur(
    id: 'USR-001',
    nom: 'Admin ImmoPro',
    email: 'admin@immopro.cm',
    telephone: '+237 690000000',
    role: Role.admin,
    statut: StatutUtilisateur.actif,
    motDePasseHashOuClairDemo: 'admin123',
    dateInscription: DateTime(2024, 1, 10),
  ),
  Utilisateur(
    id: 'USR-002',
    nom: 'Agent Kouam',
    email: 'agent@immopro.cm',
    telephone: '+237 699000002',
    role: Role.agent,
    statut: StatutUtilisateur.actif,
    motDePasseHashOuClairDemo: 'agent123',
    dateInscription: DateTime(2024, 2, 5),
  ),
  Utilisateur(
    id: 'USR-003',
    nom: 'Agent Mbarga',
    email: 'agent2@immopro.cm',
    telephone: '+237 699000001',
    role: Role.agent,
    statut: StatutUtilisateur.actif,
    motDePasseHashOuClairDemo: 'agent123',
    dateInscription: DateTime(2024, 3, 1),
  ),
  Utilisateur(
    id: 'USR-004',
    nom: 'Client Demo',
    email: 'client@immopro.cm',
    telephone: '+237 677000004',
    role: Role.client,
    statut: StatutUtilisateur.actif,
    motDePasseHashOuClairDemo: 'client123',
    dateInscription: DateTime(2025, 6, 15),
  ),
];
