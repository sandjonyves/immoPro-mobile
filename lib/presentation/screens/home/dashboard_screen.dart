import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:immopro/application/auth/auth_cubit.dart';
import 'package:immopro/application/auth/auth_state.dart';
import 'package:immopro/application/dashboard/dashboard_cubit.dart';
import 'package:immopro/application/dashboard/dashboard_state.dart';
import 'package:immopro/application/terrain/terrain_cubit.dart';
import 'package:immopro/core/theme/app_colors.dart';
import 'package:immopro/core/theme/app_text_styles.dart';
import 'package:immopro/domain/utilisateur/value_objects/role.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().charger();
    context.read<TerrainCubit>().chargerListe();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state;
    if (auth is AuthAuthenticated && auth.utilisateur.role == Role.client) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/explorer');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Tableau de bord')),
      body: BlocBuilder<DashboardCubit, DashboardState?>(
        builder: (context, dash) {
          if (dash == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _Kpi(title: 'Biens', value: '${dash.biensTotal}'),
                  _Kpi(title: 'Dispo / négo', value: '${dash.biensDisponibles}'),
                  _Kpi(title: 'Audits actifs', value: '${dash.servicesAuditActifs}'),
                  _Kpi(title: 'Utilisateurs', value: '${dash.utilisateurs}'),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Biens ajoutés (aperçu)',
                style: AppTextStyles.syneHeading(context, size: 18),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, m) => Text('M${v.toInt() + 1}'),
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: true, reservedSize: 28),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    barGroups: [
                      for (var i = 0; i < 6; i++)
                        BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: (i + 1) * 1.0,
                              width: 14,
                              color: AppColors.primaryLight,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  final String title;
  final String value;

  const _Kpi({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.interLabel(context)),
              const SizedBox(height: 8),
              Text(value, style: AppTextStyles.syneHeading(context, size: 22)),
            ],
          ),
        ),
      ),
    );
  }
}
