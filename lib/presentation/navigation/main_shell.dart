import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/auth/auth_cubit.dart';
import '../../application/auth/auth_state.dart';
import 'main_navigation.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state;
    if (auth is! AuthAuthenticated) {
      return child;
    }

    final items = navItemsForRole(auth.utilisateur.role);
    final loc = GoRouterState.of(context).uri.path;

    final sorted = [...items]
      ..sort((a, b) => b.route.length.compareTo(a.route.length));

    var selected = 0;
    for (final it in sorted) {
      final r = it.route;
      if (loc == r || loc.startsWith('$r/')) {
        selected = items.indexOf(it);
        break;
      }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected.clamp(0, items.length - 1),
        onDestinationSelected: (index) => context.go(items[index].route),
        destinations: [
          for (final it in items)
            NavigationDestination(icon: Icon(it.icon), label: it.label),
        ],
      ),
    );
  }
}
