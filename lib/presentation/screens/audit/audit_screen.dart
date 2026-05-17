import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:immopro/application/audit/audit_cubit.dart';
import 'package:immopro/application/audit/audit_state.dart';
import 'package:immopro/domain/audit/value_objects/categorie_audit.dart';

class AuditScreen extends StatefulWidget {
  const AuditScreen({super.key});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuditCubit>().charger();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services d\'audit')),
      body: BlocBuilder<AuditCubit, AuditState>(
        builder: (context, state) {
          final filtre = state is AuditListLoaded ? state.filtre : null;
          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('Tous'),
                      selected: filtre == null,
                      onSelected: (_) =>
                          context.read<AuditCubit>().appliquerFiltre(null),
                    ),
                    const SizedBox(width: 8),
                    for (final c in CategorieAudit.values)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(c.label.split(' ').last),
                          selected: filtre == c,
                          onSelected: (_) =>
                              context.read<AuditCubit>().appliquerFiltre(c),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: _liste(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _liste(AuditState state) {
    if (state is AuditLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is AuditError) {
      return Center(child: Text(state.message));
    }
    if (state is AuditListLoaded) {
      final list = state.services.where((s) => s.actif).toList();
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: list.length,
        itemBuilder: (_, i) {
          final s = list[i];
          return Card(
            child: ListTile(
              leading:
                  Text(s.categorie.icone, style: const TextStyle(fontSize: 28)),
              title: Text(s.titre),
              subtitle: Text(
                s.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/audit/${s.id}'),
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}
