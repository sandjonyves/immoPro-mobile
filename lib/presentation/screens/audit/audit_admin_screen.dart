import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:immopro/application/audit/audit_cubit.dart';
import 'package:immopro/application/audit/audit_state.dart';
import 'package:immopro/domain/audit/use_cases/modifier_service_audit.dart';

class AuditAdminScreen extends StatefulWidget {
  const AuditAdminScreen({super.key});

  @override
  State<AuditAdminScreen> createState() => _AuditAdminScreenState();
}

class _AuditAdminScreenState extends State<AuditAdminScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuditCubit>().chargerAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audit — administration')),
      body: BlocBuilder<AuditCubit, AuditState>(
        builder: (context, state) {
          if (state is AuditLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is! AuditListLoaded) {
            return const SizedBox.shrink();
          }
          return ListView.builder(
            itemCount: state.services.length,
            itemBuilder: (_, i) {
              final s = state.services[i];
              return SwitchListTile(
                title: Text(s.titre),
                subtitle: Text(s.categorie.label),
                value: s.actif,
                onChanged: (v) {
                  context.read<AuditCubit>().modifierService(
                        ModifierServiceAuditInput(id: s.id, actif: v),
                      );
                },
              );
            },
          );
        },
      ),
    );
  }
}
