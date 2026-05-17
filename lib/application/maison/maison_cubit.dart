import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/maison/repositories/i_maison_repository.dart';
import '../../domain/maison/use_cases/creer_maison.dart';
import '../../domain/maison/use_cases/lister_maisons.dart';
import '../../domain/maison/use_cases/modifier_maison.dart';
import '../../domain/maison/use_cases/obtenir_maison.dart';
import '../../domain/maison/use_cases/rechercher_maisons.dart';
import '../../domain/maison/use_cases/supprimer_maison.dart';
import '../../domain/whatsapp/use_cases/contacter_pour_maison.dart';
import 'maison_state.dart';

class MaisonCubit extends Cubit<MaisonState> {
  final ListerMaisons _listerMaisons;
  final RechercherMaisons _rechercherMaisons;
  final ObtenirMaison _obtenirMaison;
  final CreerMaison _creerMaison;
  final ModifierMaison _modifierMaison;
  final SupprimerMaison _supprimerMaison;
  final ContacterPourMaison _contacterPourMaison;

  MaisonCubit({
    required ListerMaisons listerMaisons,
    required RechercherMaisons rechercherMaisons,
    required ObtenirMaison obtenirMaison,
    required CreerMaison creerMaison,
    required ModifierMaison modifierMaison,
    required SupprimerMaison supprimerMaison,
    required ContacterPourMaison contacterPourMaison,
  })  : _listerMaisons = listerMaisons,
        _rechercherMaisons = rechercherMaisons,
        _obtenirMaison = obtenirMaison,
        _creerMaison = creerMaison,
        _modifierMaison = modifierMaison,
        _supprimerMaison = supprimerMaison,
        _contacterPourMaison = contacterPourMaison,
        super(const MaisonInitial());

  Future<void> chargerListe() async {
    emit(const MaisonLoading());
    try {
      final maisons = await _listerMaisons.execute();
      emit(MaisonListLoaded(maisons));
    } catch (e) {
      emit(MaisonError(e.toString()));
    }
  }

  Future<void> rechercher(CritereRechercheMaison criteres) async {
    emit(const MaisonLoading());
    try {
      final maisons = await _rechercherMaisons.execute(criteres);
      emit(MaisonListLoaded(maisons));
    } catch (e) {
      emit(MaisonError(e.toString()));
    }
  }

  Future<void> chargerDetail(String id) async {
    emit(const MaisonLoading());
    try {
      final m = await _obtenirMaison.execute(id);
      if (m == null) {
        emit(const MaisonError('Maison introuvable.'));
        return;
      }
      emit(MaisonDetailLoaded(m));
    } catch (e) {
      emit(MaisonError(e.toString()));
    }
  }

  Future<void> creer(CreerMaisonInput input) async {
    emit(const MaisonLoading());
    try {
      await _creerMaison.execute(input);
      await chargerListe();
    } catch (e) {
      emit(MaisonError(e.toString()));
    }
  }

  Future<void> modifier(ModifierMaisonInput input) async {
    emit(const MaisonLoading());
    try {
      await _modifierMaison.execute(input);
      await chargerDetail(input.id);
    } catch (e) {
      emit(MaisonError(e.toString()));
    }
  }

  Future<void> supprimer(String id) async {
    try {
      await _supprimerMaison.execute(id);
      await chargerListe();
    } catch (e) {
      emit(MaisonError(e.toString()));
    }
  }

  Future<void> contacterViaWhatsApp({
    required String maisonId,
    required String? nomClient,
  }) async {
    try {
      await _contacterPourMaison.execute(
        maisonId: maisonId,
        nomClient: nomClient,
      );
    } catch (e) {
      emit(MaisonError(e.toString()));
    }
  }
}
