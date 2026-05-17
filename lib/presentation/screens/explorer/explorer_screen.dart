import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:immopro/application/audit/audit_cubit.dart';
import 'package:immopro/application/audit/audit_state.dart';
import 'package:immopro/application/maison/maison_cubit.dart';
import 'package:immopro/application/maison/maison_state.dart';
import 'package:immopro/application/terrain/terrain_cubit.dart';
import 'package:immopro/application/terrain/terrain_state.dart';
import 'package:immopro/core/theme/app_text_styles.dart';
import 'package:immopro/core/widgets/section_header.dart';
import 'package:immopro/domain/maison/repositories/i_maison_repository.dart';
import 'package:immopro/domain/maison/value_objects/statut_maison.dart';
import 'package:immopro/domain/terrain/repositories/i_terrain_repository.dart';
import 'package:immopro/domain/terrain/value_objects/statut_terrain.dart';
import 'package:immopro/presentation/screens/maisons/widgets/maison_card.dart';
import 'package:immopro/presentation/screens/terrains/widgets/terrain_card.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TerrainCubit>().chargerListe();
    context.read<MaisonCubit>().chargerListe();
    context.read<AuditCubit>().charger();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explorer')),
      body: RefreshIndicator(
        onRefresh: () async {
          final terrains = context.read<TerrainCubit>();
          final maisons = context.read<MaisonCubit>();
          final audits = context.read<AuditCubit>();
          await terrains.chargerListe();
          await maisons.chargerListe();
          await audits.charger();
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Rechercher un terrain, une maison…',
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (q) {
                  context.read<TerrainCubit>().rechercher(
                        CritereRechercheTerrain(query: q),
                      );
                  context.read<MaisonCubit>().rechercher(
                        CritereRechercheMaison(query: q),
                      );
                },
              ),
            ),
            BlocBuilder<TerrainCubit, TerrainState>(
              builder: (context, ts) {
                if (ts is! TerrainListLoaded) return const SizedBox.shrink();
                final cutoff = DateTime.now().subtract(const Duration(days: 7));
                final news =
                    ts.terrains.where((t) => t.dateAjout.isAfter(cutoff)).toList();
                if (news.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Nouveautés',
                      trailing: TextButton(
                        onPressed: () => context.go('/terrains'),
                        child: const Text('Voir tout'),
                      ),
                    ),
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: news.length,
                        itemBuilder: (_, i) => SizedBox(
                          width: 280,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: TerrainCard(terrain: news[i]),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            BlocBuilder<TerrainCubit, TerrainState>(
              builder: (context, ts) {
                if (ts is! TerrainListLoaded) return const SizedBox.shrink();
                final list = ts.terrains
                    .where((t) => t.statut == StatutTerrain.disponible)
                    .take(5)
                    .toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Terrains disponibles',
                      trailing: TextButton(
                        onPressed: () => context.go('/terrains'),
                        child: const Text('Voir tout'),
                      ),
                    ),
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: list.length,
                        itemBuilder: (_, i) => SizedBox(
                          width: 280,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: TerrainCard(terrain: list[i]),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            BlocBuilder<MaisonCubit, MaisonState>(
              builder: (context, ms) {
                if (ms is! MaisonListLoaded) return const SizedBox.shrink();
                final list = ms.maisons
                    .where((m) => m.statut == StatutMaison.disponible)
                    .take(5)
                    .toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Maisons disponibles',
                      trailing: TextButton(
                        onPressed: () => context.go('/maisons'),
                        child: const Text('Voir tout'),
                      ),
                    ),
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: list.length,
                        itemBuilder: (_, i) => SizedBox(
                          width: 280,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: MaisonCard(maison: list[i]),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            BlocBuilder<AuditCubit, AuditState>(
              builder: (context, as) {
                if (as is! AuditListLoaded) return const SizedBox.shrink();
                final three = as.services.take(3).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Services d\'audit',
                      trailing: TextButton(
                        onPressed: () => context.go('/audit'),
                        child: const Text('Voir tout'),
                      ),
                    ),
                    ...three.map(
                      (s) => ListTile(
                        leading: Text(s.categorie.icone),
                        title: Text(s.titre),
                        subtitle: Text(
                          s.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => context.push('/audit/${s.id}'),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Catégories',
                style: AppTextStyles.syneHeading(context, size: 18),
              ),
            ),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('Terrains'),
                  onPressed: () => context.go('/terrains'),
                ),
                ActionChip(
                  label: const Text('Maisons'),
                  onPressed: () => context.go('/maisons'),
                ),
                ActionChip(
                  label: const Text('Audit'),
                  onPressed: () => context.go('/audit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
