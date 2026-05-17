import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:immopro/application/theme/theme_cubit.dart';

class ParametresScreen extends StatelessWidget {
  const ParametresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeCubit>().state;
    final dark = mode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          const ListTile(title: Text('Apparence')),
          SwitchListTile(
            title: const Text('Mode sombre'),
            secondary: Icon(dark ? Icons.dark_mode : Icons.light_mode),
            value: dark,
            onChanged: (_) => context.read<ThemeCubit>().basculer(),
          ),
          const ListTile(title: Text('Notifications')),
          SwitchListTile(
            title: const Text('Nouveaux biens'),
            value: true,
            onChanged: (_) {},
          ),
          SwitchListTile(
            title: const Text('Promotions'),
            value: false,
            onChanged: (_) {},
          ),
          const Divider(),
          const ListTile(title: Text('À propos')),
          const ListTile(
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
          ListTile(
            title: const Text('Conditions d\'utilisation'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Politique de confidentialité'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
