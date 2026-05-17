import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:immopro/application/audit/audit_cubit.dart';
import 'package:immopro/application/auth/auth_cubit.dart';
import 'package:immopro/application/dashboard/dashboard_cubit.dart';
import 'package:immopro/application/favoris/favoris_cubit.dart';
import 'package:immopro/application/maison/maison_cubit.dart';
import 'package:immopro/application/terrain/terrain_cubit.dart';
import 'package:immopro/application/theme/theme_cubit.dart';
import 'package:immopro/application/users/users_cubit.dart';
import 'package:immopro/core/di/service_locator.dart';
import 'package:immopro/core/theme/app_theme.dart';
import 'package:immopro/presentation/router/app_router.dart';
import 'package:immopro/presentation/router/auth_router_refresh.dart';

class ImmoProApp extends StatefulWidget {
  const ImmoProApp({super.key});

  @override
  State<ImmoProApp> createState() => _ImmoProAppState();
}

class _ImmoProAppState extends State<ImmoProApp> {
  late final AuthRouterRefresh _refresh;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _refresh = AuthRouterRefresh(sl<AuthCubit>().stream);
    _router = createAppRouter(_refresh);
  }

  @override
  void dispose() {
    _refresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: sl<AuthCubit>()),
        BlocProvider<ThemeCubit>.value(value: sl<ThemeCubit>()),
        BlocProvider<TerrainCubit>.value(value: sl<TerrainCubit>()),
        BlocProvider<MaisonCubit>.value(value: sl<MaisonCubit>()),
        BlocProvider<AuditCubit>.value(value: sl<AuditCubit>()),
        BlocProvider<FavorisCubit>.value(value: sl<FavorisCubit>()),
        BlocProvider<DashboardCubit>.value(value: sl<DashboardCubit>()),
        BlocProvider<UsersCubit>.value(value: sl<UsersCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp.router(
            title: 'ImmoPro',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: mode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
