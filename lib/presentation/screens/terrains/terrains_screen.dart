import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:immopro/application/auth/auth_cubit.dart';
import 'package:immopro/application/auth/auth_state.dart';
import 'package:immopro/application/favoris/favoris_cubit.dart';
import 'package:immopro/application/terrain/terrain_cubit.dart';
import 'package:immopro/application/terrain/terrain_state.dart';
import 'package:immopro/core/widgets/empty_state.dart';
import 'package:immopro/core/widgets/error_state.dart';
import 'package:immopro/core/widgets/loading_overlay.dart';
import 'package:immopro/domain/terrain/repositories/i_terrain_repository.dart';
import 'package:immopro/domain/terrain/value_objects/statut_terrain.dart';
import 'package:immopro/domain/utilisateur/value_objects/role.dart';
import 'package:immopro/presentation/screens/terrains/widgets/terrain_card.dart';

class TerrainsScreen extends StatefulWidget {
  const TerrainsScreen({super.key});

  @override
  State<TerrainsScreen> createState() => _TerrainsScreenState();
}

class _TerrainsScreenState extends State<TerrainsScreen> {
  StatutTerrain? _filtreStatut;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TerrainCubit>().chargerListe();
    context.read<FavorisCubit>().charger();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _appliquerFiltres() {
    context.read<TerrainCubit>().rechercher(
          CritereRechercheTerrain(
            query: _search.text.isEmpty ? null : _search.text,
            statut: _filtreStatut,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state;
    final canCrud = auth is AuthAuthenticated &&
        (auth.utilisateur.role == Role.admin ||
            auth.utilisateur.role == Role.agent);

    return Scaffold(
      appBar: AppBar(title: const Text('Terrains')),
      floatingActionButton: canCrud
          ? FloatingActionButton(
              onPressed: () => context.push('/terrains/nouveau'),
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: 'Rechercher…',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) => _appliquerFiltres(),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Tous'),
                  selected: _filtreStatut == null,
                  onSelected: (_) {
                    setState(() => _filtreStatut = null);
                    _appliquerFiltres();
                  },
                ),
                const SizedBox(width: 8),
                for (final s in [
                  StatutTerrain.disponible,
                  StatutTerrain.enNegociation,
                  StatutTerrain.vendu,
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(s.label),
                      selected: _filtreStatut == s,
                      onSelected: (_) {
                        setState(() => _filtreStatut = s);
                        _appliquerFiltres();
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TerrainCubit, TerrainState>(
              builder: (context, state) {
                if (state is TerrainLoading) return const LoadingOverlay();
                if (state is TerrainError) {
                  return ErrorState(
                    message: state.message,
                    onRetry: () => context.read<TerrainCubit>().chargerListe(),
                  );
                }
                if (state is TerrainListLoaded) {
                  if (state.terrains.isEmpty) {
                    return const EmptyState(message: 'Aucun terrain');
                  }
                  return RefreshIndicator(
                    onRefresh: () => context.read<TerrainCubit>().chargerListe(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: state.terrains.length,
                      itemBuilder: (_, i) {
                        final t = state.terrains[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TerrainCard(
                            terrain: t,
                            favori: context.watch<FavorisCubit>().terrainEstFavori(t.id),
                            onFavoriteToggle: () => context
                                .read<FavorisCubit>()
                                .basculerTerrain(t.id),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
