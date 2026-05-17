import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import 'package:immopro/application/auth/auth_cubit.dart';
import 'package:immopro/application/auth/auth_state.dart';
import 'package:immopro/application/maison/maison_cubit.dart';
import 'package:immopro/application/maison/maison_state.dart';
import 'package:immopro/core/theme/app_colors.dart';
import 'package:immopro/core/theme/app_text_styles.dart';
import 'package:immopro/core/widgets/confirm_dialog.dart';
import 'package:immopro/core/widgets/loading_overlay.dart';
import 'package:immopro/core/widgets/price_text.dart';
import 'package:immopro/core/widgets/whatsapp_cta_button.dart';
import 'package:immopro/domain/maison/value_objects/statut_maison.dart';
import 'package:immopro/domain/utilisateur/value_objects/role.dart';

class MaisonDetailScreen extends StatefulWidget {
  final String maisonId;

  const MaisonDetailScreen({super.key, required this.maisonId});

  @override
  State<MaisonDetailScreen> createState() => _MaisonDetailScreenState();
}

class _MaisonDetailScreenState extends State<MaisonDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MaisonCubit>().chargerDetail(widget.maisonId);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state;
    final canManage = auth is AuthAuthenticated &&
        (auth.utilisateur.role == Role.admin ||
            auth.utilisateur.role == Role.agent);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maison'),
        actions: [
          if (canManage)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () =>
                  context.push('/maisons/${widget.maisonId}/edit'),
            ),
        ],
      ),
      body: BlocConsumer<MaisonCubit, MaisonState>(
        listener: (context, state) {
          if (state is MaisonError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is MaisonLoading) return const LoadingOverlay();
          if (state is! MaisonDetailLoaded) {
            return const Center(child: Text('Chargement…'));
          }
          final m = state.maison;
          final pt = LatLng(m.localisation.latitude, m.localisation.longitude);
          final showWa = m.statut == StatutMaison.disponible ||
              m.statut == StatutMaison.enNegociation;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.grey.shade300,
                        child: m.photos.isEmpty
                            ? const Icon(Icons.house, size: 64)
                            : Image.network(
                                m.photos.first,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.titre, style: AppTextStyles.syneHeading(context)),
                          Text(m.type.label, style: AppTextStyles.interBody(context)),
                          PriceText(montant: m.prix),
                          Text(
                            '${m.quartier}, ${m.ville}',
                            style: AppTextStyles.interBody(context),
                          ),
                          Text(
                            '${m.surfaceHabitableM2.toStringAsFixed(0)} m² · '
                            '${m.chambres} ch. · ${m.sallesDeBain} SDB',
                            style: AppTextStyles.interBody(context),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: FlutterMap(
                        options: MapOptions(initialCenter: pt, initialZoom: 16),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.immopro.app',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: pt,
                                width: 40,
                                height: 40,
                                child: const Icon(Icons.location_pin, size: 40),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(m.description, style: AppTextStyles.interBody(context)),
                    ),
                    if (canManage)
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
                            message: 'Supprimer cette maison ?',
                            confirmLabel: 'Supprimer',
                          );
                          if (ok == true && context.mounted) {
                            await context.read<MaisonCubit>().supprimer(m.id);
                            if (context.mounted) context.pop();
                          }
                        },
                      ),
                    const SizedBox(height: 88),
                  ],
                ),
              ),
              if (showWa)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: WhatsAppCtaButton(
                      label: 'Contacter l\'agent',
                      sublabel: 'Via WhatsApp · hors application',
                      onPressed: () =>
                          context.read<MaisonCubit>().contacterViaWhatsApp(
                                maisonId: m.id,
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
