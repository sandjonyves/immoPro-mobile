import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlusScreen extends StatelessWidget {
  const PlusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plus')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Utilisateurs'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/utilisateurs'),
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings_outlined),
            title: const Text('Services d\'audit (admin)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/audit-admin'),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Paramètres'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/parametres'),
          ),
        ],
      ),
    );
  }
}
