import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:immopro/application/users/users_cubit.dart';
import 'package:immopro/application/users/users_state.dart';
import 'package:immopro/domain/utilisateur/value_objects/role.dart';

class UtilisateursScreen extends StatefulWidget {
  const UtilisateursScreen({super.key});

  @override
  State<UtilisateursScreen> createState() => _UtilisateursScreenState();
}

class _UtilisateursScreenState extends State<UtilisateursScreen> {
  Role? _filtre;

  @override
  void initState() {
    super.initState();
    context.read<UsersCubit>().charger();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Utilisateurs')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Tous'),
                  selected: _filtre == null,
                  onSelected: (_) {
                    setState(() => _filtre = null);
                    context.read<UsersCubit>().charger(filtre: null);
                  },
                ),
                const SizedBox(width: 8),
                for (final r in Role.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(r.label),
                      selected: _filtre == r,
                      onSelected: (_) {
                        setState(() => _filtre = r);
                        context.read<UsersCubit>().charger(filtre: r);
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<UsersCubit, UsersState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.utilisateurs.length,
                  itemBuilder: (_, i) {
                    final u = state.utilisateurs[i];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          u.nom.isNotEmpty ? u.nom[0].toUpperCase() : '?',
                        ),
                      ),
                      title: Text(u.nom),
                      subtitle: Text(u.email),
                      trailing: Chip(label: Text(u.role.label)),
                      onLongPress: () async {
                        final next = await showDialog<Role>(
                          context: context,
                          builder: (ctx) => SimpleDialog(
                            title: const Text('Changer le rôle'),
                            children: Role.values
                                .map(
                                  (r) => SimpleDialogOption(
                                    onPressed: () => Navigator.pop(ctx, r),
                                    child: Text(r.label),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                        if (next != null && context.mounted) {
                          await context.read<UsersCubit>().modifierRole(
                                id: u.id,
                                role: next,
                              );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
