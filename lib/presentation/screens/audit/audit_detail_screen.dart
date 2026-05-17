import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:immopro/application/audit/audit_cubit.dart';
import 'package:immopro/application/audit/audit_state.dart';
import 'package:immopro/application/auth/auth_cubit.dart';
import 'package:immopro/application/auth/auth_state.dart';
import 'package:immopro/core/theme/app_text_styles.dart';
import 'package:immopro/core/widgets/whatsapp_cta_button.dart';

class AuditDetailScreen extends StatefulWidget {
  final String serviceId;

  const AuditDetailScreen({super.key, required this.serviceId});

  @override
  State<AuditDetailScreen> createState() => _AuditDetailScreenState();
}

class _AuditDetailScreenState extends State<AuditDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuditCubit>().chargerDetail(widget.serviceId);
  }

  Future<void> _confirmerEtContacter() async {
    final desc = TextEditingController();
    final nom = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).utilisateur.nom
        : null;

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Vous allez être redirigé vers WhatsApp pour contacter notre équipe.',
              style: AppTextStyles.interBody(ctx),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: desc,
              decoration: const InputDecoration(
                labelText: 'Décrivez brièvement votre bien (optionnel)',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Continuer vers WhatsApp'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler'),
            ),
          ],
        ),
      ),
    );

    if (ok == true && mounted) {
      await context.read<AuditCubit>().contacterViaWhatsApp(
            serviceId: widget.serviceId,
            nomClient: nom,
            descriptionBien: desc.text.isEmpty ? null : desc.text,
          );
    }
    desc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service d\'audit')),
      body: BlocConsumer<AuditCubit, AuditState>(
        listener: (context, state) {
          if (state is AuditError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuditLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! AuditDetailLoaded) {
            return const Center(child: Text('Chargement…'));
          }
          final s = state.service;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      '${s.categorie.icone} ${s.categorie.label}',
                      style: AppTextStyles.interBody(context),
                    ),
                    Text(s.titre, style: AppTextStyles.syneHeading(context)),
                    const SizedBox(height: 8),
                    Text(s.descriptionDetaillee, style: AppTextStyles.interBody(context)),
                    const SizedBox(height: 16),
                    Text('Inclus', style: AppTextStyles.syneTitle(context)),
                    for (final x in s.inclusions)
                      ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.green),
                        title: Text(x),
                      ),
                    Text('Documents à fournir', style: AppTextStyles.syneTitle(context)),
                    for (final x in s.documents)
                      ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: Text(x),
                      ),
                    ListTile(
                      title: const Text('Durée estimée'),
                      subtitle: Text(s.dureeEstimee),
                    ),
                    ListTile(
                      title: const Text('Tarif indicatif'),
                      subtitle: Text(s.tarif.affichage),
                    ),
                    Text(
                      'Le tarif est indicatif. Le devis final est établi après échange avec notre équipe.',
                      style: AppTextStyles.interLabel(context),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: WhatsAppCtaButton(
                    label: 'Demander ce service',
                    sublabel: 'Réponse sous 24h • Via WhatsApp',
                    onPressed: _confirmerEtContacter,
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
