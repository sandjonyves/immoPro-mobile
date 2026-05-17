import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import 'package:immopro/application/maison/maison_cubit.dart';
import 'package:immopro/application/maison/maison_state.dart';
import 'package:immopro/application/terrain/terrain_cubit.dart';
import 'package:immopro/application/terrain/terrain_state.dart';
import 'package:immopro/core/theme/app_colors.dart';
import 'package:immopro/domain/maison/value_objects/statut_maison.dart';
import 'package:immopro/domain/terrain/value_objects/statut_terrain.dart';

class CarteScreen extends StatefulWidget {
  const CarteScreen({super.key});

  @override
  State<CarteScreen> createState() => _CarteScreenState();
}

class _CarteScreenState extends State<CarteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TerrainCubit>().chargerListe();
    context.read<MaisonCubit>().chargerListe();
  }

  Color _poly(BuildContext context, StatutTerrain s) {
    final d = AppColors.isDark(context);
    return switch (s) {
      StatutTerrain.disponible =>
        d ? AppColors.mapDisponibleD : AppColors.mapDisponibleL,
      StatutTerrain.enNegociation =>
        d ? AppColors.mapNegoD : AppColors.mapNegoL,
      StatutTerrain.vendu => d ? AppColors.mapVenduD : AppColors.mapVenduL,
      StatutTerrain.loue => d ? AppColors.mapLoueD : AppColors.mapLoueL,
      _ => d ? AppColors.mapArchiveD : AppColors.mapArchiveL,
    };
  }

  Color _markerMaison(BuildContext context, StatutMaison s) {
    final d = AppColors.isDark(context);
    return switch (s) {
      StatutMaison.disponible =>
        d ? AppColors.mapDisponibleD : AppColors.mapDisponibleL,
      StatutMaison.enNegociation =>
        d ? AppColors.mapNegoD : AppColors.mapNegoL,
      StatutMaison.vendu => d ? AppColors.mapVenduD : AppColors.mapVenduL,
      StatutMaison.loue => d ? AppColors.mapLoueD : AppColors.mapLoueL,
      StatutMaison.travaux =>
        d ? AppColors.mapArchiveD : AppColors.mapArchiveL,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carte')),
      body: BlocBuilder<TerrainCubit, TerrainState>(
        builder: (context, ts) {
          return BlocBuilder<MaisonCubit, MaisonState>(
            builder: (context, ms) {
              if (ts is! TerrainListLoaded || ms is! MaisonListLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              final polygons = ts.terrains.map((t) {
                final pts = t.bornes
                    .map((b) => LatLng(b.latitude, b.longitude))
                    .toList();
                return Polygon(
                  points: pts,
                  color: _poly(context, t.statut).withValues(alpha: 0.35),
                  borderColor: _poly(context, t.statut),
                  borderStrokeWidth: 2,
                );
              }).toList();

              final markers = ms.maisons.map((m) {
                return Marker(
                  point:
                      LatLng(m.localisation.latitude, m.localisation.longitude),
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons.home,
                    color: _markerMaison(context, m.statut),
                    size: 32,
                  ),
                );
              }).toList();

              return FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(3.8667, 11.5167),
                  initialZoom: 11,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.immopro.app',
                  ),
                  PolygonLayer(polygons: polygons),
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      maxClusterRadius: 48,
                      size: const Size(40, 40),
                      markers: markers,
                      builder: (ctx, clusterMarkers) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${clusterMarkers.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
