import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import 'package:immopro/application/auth/auth_cubit.dart';
import 'package:immopro/application/auth/auth_state.dart';
import 'package:immopro/application/terrain/terrain_cubit.dart';
import 'package:immopro/application/terrain/terrain_state.dart';
import 'package:immopro/core/theme/app_colors.dart';
import 'package:immopro/core/theme/app_text_styles.dart';
import 'package:immopro/core/widgets/confirm_dialog.dart';
import 'package:immopro/core/widgets/loading_overlay.dart';
import 'package:immopro/core/widgets/price_text.dart';
import 'package:immopro/core/widgets/whatsapp_cta_button.dart';
import 'package:immopro/core/widgets/section_header.dart';
import 'package:immopro/core/utils/formatters.dart';
import 'package:immopro/domain/terrain/value_objects/statut_terrain.dart';
import 'package:immopro/domain/utilisateur/value_objects/role.dart';

class TerrainDetailScreen extends StatefulWidget {
  final String terrainId;

  const TerrainDetailScreen({super.key, required this.terrainId});

  @override
  State<TerrainDetailScreen> createState() => _TerrainDetailScreenState();
}

class _TerrainDetailScreenState extends State<TerrainDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TerrainCubit>().chargerDetail(widget.terrainId);
  }

  Color _couleurPolygone(BuildContext context, StatutTerrain s) {
    final dark = AppColors.isDark(context);
    return switch (s) {
      StatutTerrain.disponible =>
        dark ? AppColors.mapDisponibleD : AppColors.mapDisponibleL,
      StatutTerrain.enNegociation =>
        dark ? AppColors.mapNegoD : AppColors.mapNegoL,
      StatutTerrain.vendu => dark ? AppColors.mapVenduD : AppColors.mapVenduL,
      StatutTerrain.loue => dark ? AppColors.mapLoueD : AppColors.mapLoueL,
      StatutTerrain.travaux =>
        dark ? AppColors.mapArchiveD : AppColors.mapArchiveL,
      StatutTerrain.archive =>
        dark ? AppColors.mapArchiveD : AppColors.mapArchiveL,
    };
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state;
    final canManage = auth is AuthAuthenticated &&
        (auth.utilisateur.role == Role.admin ||
            auth.utilisateur.role == Role.agent);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terrain'),
        actions: [
          if (canManage)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () =>
                  context.push('/terrains/${widget.terrainId}/edit'),
            ),
        ],
      ),
      body: BlocConsumer<TerrainCubit, TerrainState>(
        listener: (context, state) {
          if (state is TerrainError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is TerrainLoading) return const LoadingOverlay();
          if (state is! TerrainDetailLoaded) {
            return const Center(child: Text('Chargement…'));
          }
          final t = state.terrain;
          final pts =
              t.bornes.map((b) => LatLng(b.latitude, b.longitude)).toList();
          final showWa = t.statut == StatutTerrain.disponible ||
              t.statut == StatutTerrain.enNegociation;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: 220,
                      child: PageView(
                        children: [
                          Container(
                            color: Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: t.photos.isEmpty
                                ? const Icon(Icons.terrain, size: 64)
                                : Image.network(
                                    t.photos.first,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.terrain, size: 64),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.titre, style: AppTextStyles.syneHeading(context)),
                          const SizedBox(height: 8),
                          Text(
                            '${t.surfaceM2.formate} · ${t.quartier}, ${t.ville}',
                            style: AppTextStyles.interBody(context),
                          ),
                          const SizedBox(height: 8),
                          PriceText(montant: t.prix),
                        ],
                      ),
                    ),
                    const SectionHeader(title: 'Localisation'),
                    SizedBox(
                      height: 220,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: pts.first,
                          initialZoom: 16,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.immopro.app',
                          ),
                          PolygonLayer(
                            polygons: [
                              Polygon(
                                points: pts,
                                color: _couleurPolygone(context, t.statut)
                                    .withValues(alpha: 0.35),
                                borderColor:
                                    _couleurPolygone(context, t.statut),
                                borderStrokeWidth: 2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bornes GPS',
                            style: AppTextStyles.syneTitle(context),
                          ),
                          for (var i = 0; i < t.bornes.length; i++)
                            Text(
                              'Borne $i : ${Formatters.gps4(t.bornes[i].latitude)}, '
                              '${Formatters.gps4(t.bornes[i].longitude)}',
                              style: AppTextStyles.interBody(context, size: 13),
                            ),
                        ],
                      ),
                    ),
                    const SectionHeader(title: 'Informations'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(t.description, style: AppTextStyles.interBody(context)),
                    ),
                    ListTile(
                      title: const Text('Titre foncier'),
                      subtitle: Text(t.titreFoncier),
                    ),
                    ListTile(
                      title: const Text('Date d\'ajout'),
                      subtitle: Text(Formatters.dateCourt(t.dateAjout)),
                    ),
                    if (canManage) ...[
                      ListTile(
                        leading: const Icon(Icons.archive_outlined),
                        title: const Text('Archiver'),
                        onTap: () async {
                          final ok = await confirmDialog(
                            context: context,
                            title: 'Archiver',
                            message: 'Archiver ce terrain ?',
                          );
                          if (ok == true && context.mounted) {
                            await context.read<TerrainCubit>().archiver(t.id);
                            if (context.mounted) context.pop();
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline, color: AppColors.danger),
                        title: const Text(
                          'Supprimer',
                          style: TextStyle(color: AppColors.danger),
                        ),
                        onTap: () async {
                          final ok = await confirmDialog(
                            context: context,
                            title: 'Supprimer',
                            message: 'Suppression définitive ?',
                            confirmLabel: 'Supprimer',
                          );
                          if (ok == true && context.mounted) {
                            await context.read<TerrainCubit>().supprimer(t.id);
                            if (context.mounted) context.pop();
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: 96),
                  ],
                ),
              ),
              if (showWa)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: WhatsAppCtaButton(
                      label: 'Contacter l\'agent',
                      sublabel: 'Aucun engagement • Via WhatsApp',
                      onPressed: () => context.read<TerrainCubit>().contacterViaWhatsApp(
                            terrainId: t.id,
                            nomClient: auth is AuthAuthenticated
                                ? auth.utilisateur.nom
                                : null,
                          ),
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
