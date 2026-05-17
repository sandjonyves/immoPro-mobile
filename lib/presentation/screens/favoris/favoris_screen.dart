import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:immopro/application/favoris/favoris_cubit.dart';
import 'package:immopro/application/favoris/favoris_state.dart';
import 'package:immopro/application/maison/maison_cubit.dart';
import 'package:immopro/application/maison/maison_state.dart';
import 'package:immopro/application/terrain/terrain_cubit.dart';
import 'package:immopro/application/terrain/terrain_state.dart';
import 'package:immopro/presentation/screens/maisons/widgets/maison_card.dart';
import 'package:immopro/presentation/screens/terrains/widgets/terrain_card.dart';

class FavorisScreen extends StatefulWidget {
  const FavorisScreen({super.key});

  @override
  State<FavorisScreen> createState() => _FavorisScreenState();
}

class _FavorisScreenState extends State<FavorisScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    context.read<FavorisCubit>().charger();
    context.read<TerrainCubit>().chargerListe();
    context.read<MaisonCubit>().chargerListe();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Terrains'),
            Tab(text: 'Maisons'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          BlocBuilder<FavorisCubit, FavorisState>(
            builder: (context, favState) {
              return BlocBuilder<TerrainCubit, TerrainState>(
                builder: (context, ts) {
                  if (ts is! TerrainListLoaded) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final fav = favState.terrains;
                  final list =
                      ts.terrains.where((t) => fav.contains(t.id)).toList();
                  if (list.isEmpty) {
                    return const Center(child: Text('Aucun terrain favori'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Dismissible(
                        key: ValueKey(list[i].id),
                        onDismissed: (_) => context
                            .read<FavorisCubit>()
                            .basculerTerrain(list[i].id),
                        child: TerrainCard(
                          terrain: list[i],
                          favori: true,
                          onFavoriteToggle: () => context
                              .read<FavorisCubit>()
                              .basculerTerrain(list[i].id),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          BlocBuilder<FavorisCubit, FavorisState>(
            builder: (context, favState) {
              return BlocBuilder<MaisonCubit, MaisonState>(
                builder: (context, ms) {
                  if (ms is! MaisonListLoaded) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final fav = favState.maisons;
                  final list =
                      ms.maisons.where((m) => fav.contains(m.id)).toList();
                  if (list.isEmpty) {
                    return const Center(child: Text('Aucune maison favorite'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Dismissible(
                        key: ValueKey(list[i].id),
                        onDismissed: (_) => context
                            .read<FavorisCubit>()
                            .basculerMaison(list[i].id),
                        child: MaisonCard(
                          maison: list[i],
                          favori: true,
                          onFavoriteToggle: () => context
                              .read<FavorisCubit>()
                              .basculerMaison(list[i].id),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
