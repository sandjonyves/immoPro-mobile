import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:immopro/application/auth/auth_cubit.dart';
import 'package:immopro/application/auth/auth_state.dart';
import 'package:immopro/core/widgets/app_button.dart';
import 'package:immopro/core/widgets/confirm_dialog.dart';
import 'package:immopro/domain/utilisateur/value_objects/role.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state;
    if (auth is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: Text('Non connecté')));
    }
    final u = auth.utilisateur;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              u.nom.isNotEmpty ? u.nom[0].toUpperCase() : '?',
            ),
          ),
          const SizedBox(height: 12),
          Text(u.nom, style: Theme.of(context).textTheme.headlineSmall),
          Chip(label: Text(u.role.label)),
          ListTile(title: const Text('Email'), subtitle: Text(u.email)),
          ListTile(title: const Text('Téléphone'), subtitle: Text(u.telephone)),
          ListTile(
            title: const Text('Paramètres'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/parametres'),
          ),
          if (u.role == Role.client)
            ListTile(
              title: const Text('Favoris'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/favoris'),
            ),
          const SizedBox(height: 24),
          AppButton(
            variant: AppButtonVariant.secondary,
            label: 'Se déconnecter',
            onPressed: () async {
              final ok = await confirmDialog(
                context: context,
                title: 'Déconnexion',
                message: 'Confirmer la déconnexion ?',
                confirmLabel: 'Se déconnecter',
              );
              if (ok == true && context.mounted) {
                await context.read<AuthCubit>().deconnecter();
                if (context.mounted) context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
