import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:immopro/application/auth/auth_cubit.dart';
import 'package:immopro/application/auth/auth_state.dart';
import 'package:immopro/application/favoris/favoris_cubit.dart';
import 'package:immopro/application/maison/maison_cubit.dart';
import 'package:immopro/application/maison/maison_state.dart';
import 'package:immopro/core/widgets/empty_state.dart';
import 'package:immopro/core/widgets/error_state.dart';
import 'package:immopro/core/widgets/loading_overlay.dart';
import 'package:immopro/domain/utilisateur/value_objects/role.dart';
import 'package:immopro/presentation/screens/maisons/widgets/maison_card.dart';

class MaisonsScreen extends StatefulWidget {
  const MaisonsScreen({super.key});

  @override
  State<MaisonsScreen> createState() => _MaisonsScreenState();
}

class _MaisonsScreenState extends State<MaisonsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MaisonCubit>().chargerListe();
    context.read<FavorisCubit>().charger();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state;
    final canCrud = auth is AuthAuthenticated &&
        (auth.utilisateur.role == Role.admin ||
            auth.utilisateur.role == Role.agent);

    return Scaffold(
      appBar: AppBar(title: const Text('Maisons')),
      floatingActionButton: canCrud
          ? FloatingActionButton(
              onPressed: () => context.push('/maisons/nouveau'),
              child: const Icon(Icons.add),
            )
          : null,
      body: BlocBuilder<MaisonCubit, MaisonState>(
        builder: (context, state) {
          if (state is MaisonLoading) return const LoadingOverlay();
          if (state is MaisonError) {
            return ErrorState(
              message: state.message,
              onRetry: () => context.read<MaisonCubit>().chargerListe(),
            );
          }
          if (state is MaisonListLoaded) {
            if (state.maisons.isEmpty) {
              return const EmptyState(message: 'Aucune maison');
            }
            return RefreshIndicator(
              onRefresh: () => context.read<MaisonCubit>().chargerListe(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.maisons.length,
                itemBuilder: (_, i) {
                  final m = state.maisons[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MaisonCard(
                      maison: m,
                      favori:
                          context.watch<FavorisCubit>().maisonEstFavori(m.id),
                      onFavoriteToggle: () => context
                          .read<FavorisCubit>()
                          .basculerMaison(m.id),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
