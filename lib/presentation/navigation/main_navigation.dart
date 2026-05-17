import 'package:flutter/material.dart';

import '../../domain/utilisateur/value_objects/role.dart';

class NavItem {
  final IconData icon;
  final String label;
  final String route;

  const NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

List<NavItem> navItemsForRole(Role role) {
  switch (role) {
    case Role.client:
      return const [
        NavItem(icon: Icons.search_rounded, label: 'Explorer', route: '/explorer'),
        NavItem(icon: Icons.terrain_rounded, label: 'Terrains', route: '/terrains'),
        NavItem(icon: Icons.house_rounded, label: 'Maisons', route: '/maisons'),
        NavItem(icon: Icons.policy_rounded, label: 'Audit', route: '/audit'),
        NavItem(icon: Icons.person_rounded, label: 'Profil', route: '/profil'),
      ];
    case Role.agent:
      return const [
        NavItem(icon: Icons.dashboard_rounded, label: 'Accueil', route: '/dashboard'),
        NavItem(icon: Icons.terrain_rounded, label: 'Terrains', route: '/terrains'),
        NavItem(icon: Icons.house_rounded, label: 'Maisons', route: '/maisons'),
        NavItem(icon: Icons.map_rounded, label: 'Carte', route: '/carte'),
        NavItem(icon: Icons.person_rounded, label: 'Profil', route: '/profil'),
      ];
    case Role.admin:
      return const [
        NavItem(icon: Icons.dashboard_rounded, label: 'Accueil', route: '/dashboard'),
        NavItem(icon: Icons.terrain_rounded, label: 'Terrains', route: '/terrains'),
        NavItem(icon: Icons.house_rounded, label: 'Maisons', route: '/maisons'),
        NavItem(icon: Icons.policy_rounded, label: 'Audit', route: '/audit'),
        NavItem(icon: Icons.more_horiz_rounded, label: 'Plus', route: '/plus'),
      ];
  }
}

String homeRouteForRole(Role role) {
  switch (role) {
    case Role.client:
      return '/explorer';
    case Role.agent:
    case Role.admin:
      return '/dashboard';
  }
}
