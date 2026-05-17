import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/shared/errors/domain_error.dart';
import '../../domain/utilisateur/entities/utilisateur.dart';
import '../../domain/utilisateur/use_cases/obtenir_profil.dart';
import '../../domain/utilisateur/use_cases/se_connecter.dart';
import '../../domain/utilisateur/use_cases/se_deconnecter.dart';
import '../../infrastructure/services/session_storage.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SeConnecter _seConnecter;
  final SeDeconnecter _seDeconnecter;
  final ObtenirProfil _obtenirProfil;
  final SessionStorage _session;

  AuthCubit({
    required SeConnecter seConnecter,
    required SeDeconnecter seDeconnecter,
    required ObtenirProfil obtenirProfil,
    required SessionStorage session,
  })  : _seConnecter = seConnecter,
        _seDeconnecter = seDeconnecter,
        _obtenirProfil = obtenirProfil,
        _session = session,
        super(const AuthInitial());

  Future<void> restaurerSession() async {
    emit(const AuthLoading());
    final id = await _session.lireUserId();
    if (id == null) {
      emit(const AuthUnauthenticated());
      return;
    }
    try {
      final u = await _obtenirProfil.execute(id);
      emit(AuthAuthenticated(u));
    } catch (_) {
      await _session.effacer();
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> connecter({
    required String email,
    required String motDePasse,
  }) async {
    emit(const AuthLoading());
    try {
      final u = await _seConnecter.execute(email: email, motDePasse: motDePasse);
      await _session.sauverUserId(u.id);
      emit(AuthAuthenticated(u));
    } on DomainError catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> deconnecter() async {
    await _seDeconnecter.execute();
    await _session.effacer();
    emit(const AuthUnauthenticated());
  }

  Utilisateur? get utilisateurCourant {
    final s = state;
    if (s is AuthAuthenticated) return s.utilisateur;
    return null;
  }
}
