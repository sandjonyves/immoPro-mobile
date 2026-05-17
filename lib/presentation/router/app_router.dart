import 'package:go_router/go_router.dart';

import 'package:immopro/application/auth/auth_cubit.dart';
import 'package:immopro/application/auth/auth_state.dart';
import 'package:immopro/core/di/service_locator.dart';
import 'package:immopro/domain/location/use_cases/obtenir_position_actuelle.dart';
import 'package:immopro/domain/utilisateur/value_objects/role.dart';
import 'package:immopro/presentation/navigation/main_navigation.dart';
import 'package:immopro/presentation/navigation/main_shell.dart';
import 'package:immopro/presentation/router/auth_router_refresh.dart';
import 'package:immopro/presentation/screens/audit/audit_admin_screen.dart';
import 'package:immopro/presentation/screens/audit/audit_detail_screen.dart';
import 'package:immopro/presentation/screens/audit/audit_screen.dart';
import 'package:immopro/presentation/screens/auth/login_screen.dart';
import 'package:immopro/presentation/screens/carte/carte_screen.dart';
import 'package:immopro/presentation/screens/explorer/explorer_screen.dart';
import 'package:immopro/presentation/screens/favoris/favoris_screen.dart';
import 'package:immopro/presentation/screens/home/dashboard_screen.dart';
import 'package:immopro/presentation/screens/maisons/maison_detail_screen.dart';
import 'package:immopro/presentation/screens/maisons/maison_form_screen.dart';
import 'package:immopro/presentation/screens/maisons/maisons_screen.dart';
import 'package:immopro/presentation/screens/parametres/parametres_screen.dart';
import 'package:immopro/presentation/screens/plus/plus_screen.dart';
import 'package:immopro/presentation/screens/profil/profil_screen.dart';
import 'package:immopro/presentation/screens/terrains/terrain_detail_screen.dart';
import 'package:immopro/presentation/screens/terrains/terrain_form_screen.dart';
import 'package:immopro/presentation/screens/terrains/terrains_screen.dart';
import 'package:immopro/presentation/screens/users/utilisateurs_screen.dart';

GoRouter createAppRouter(AuthRouterRefresh refresh) {
  final auth = sl<AuthCubit>();

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refresh,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final loggingIn = loc == '/login';
      final s = auth.state;

      if (s is AuthInitial || s is AuthLoading) {
        return loggingIn ? null : '/login';
      }

      final authed = s is AuthAuthenticated;
      if (!authed && !loggingIn) return '/login';
      if (authed && loggingIn) {
        return homeRouteForRole(s.utilisateur.role);
      }

      if (authed) {
        final r = s.utilisateur.role;
        if (r == Role.client && loc == '/dashboard') return '/explorer';
        if (loc.startsWith('/utilisateurs') && r != Role.admin) {
          return homeRouteForRole(r);
        }
        if (loc.startsWith('/audit-admin') && r != Role.admin) {
          return homeRouteForRole(r);
        }
        if (loc.startsWith('/plus') && r != Role.admin) {
          return homeRouteForRole(r);
        }
        if (r == Role.client &&
            (loc.contains('/nouveau') || loc.endsWith('/edit'))) {
          if (loc.startsWith('/terrains')) return '/terrains';
          if (loc.startsWith('/maisons')) return '/maisons';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/explorer',
            builder: (context, state) => const ExplorerScreen(),
          ),
          GoRoute(
            path: '/terrains',
            builder: (context, state) => const TerrainsScreen(),
            routes: [
              GoRoute(
                path: 'nouveau',
                builder: (context, state) => TerrainFormScreen(
                  lecturePosition: () => sl<ObtenirPositionActuelle>().execute(),
                ),
              ),
              GoRoute(
                path: ':tid',
                builder: (context, state) => TerrainDetailScreen(
                  terrainId: state.pathParameters['tid']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => TerrainFormScreen(
                      terrainId: state.pathParameters['tid']!,
                      lecturePosition: () =>
                          sl<ObtenirPositionActuelle>().execute(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/maisons',
            builder: (context, state) => const MaisonsScreen(),
            routes: [
              GoRoute(
                path: 'nouveau',
                builder: (context, state) => MaisonFormScreen(
                  lecturePosition: () => sl<ObtenirPositionActuelle>().execute(),
                ),
              ),
              GoRoute(
                path: ':mid',
                builder: (context, state) => MaisonDetailScreen(
                  maisonId: state.pathParameters['mid']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => MaisonFormScreen(
                      maisonId: state.pathParameters['mid']!,
                      lecturePosition: () =>
                          sl<ObtenirPositionActuelle>().execute(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/audit',
            builder: (context, state) => const AuditScreen(),
            routes: [
              GoRoute(
                path: ':aid',
                builder: (context, state) => AuditDetailScreen(
                  serviceId: state.pathParameters['aid']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/carte',
            builder: (context, state) => const CarteScreen(),
          ),
          GoRoute(
            path: '/favoris',
            builder: (context, state) => const FavorisScreen(),
          ),
          GoRoute(
            path: '/profil',
            builder: (context, state) => const ProfilScreen(),
          ),
          GoRoute(
            path: '/parametres',
            builder: (context, state) => const ParametresScreen(),
          ),
          GoRoute(
            path: '/plus',
            builder: (context, state) => const PlusScreen(),
          ),
          GoRoute(
            path: '/utilisateurs',
            builder: (context, state) => const UtilisateursScreen(),
          ),
          GoRoute(
            path: '/audit-admin',
            builder: (context, state) => const AuditAdminScreen(),
          ),
        ],
      ),
    ],
  );
}
