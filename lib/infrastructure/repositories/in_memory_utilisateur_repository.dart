import '../../domain/utilisateur/entities/utilisateur.dart';
import '../../domain/utilisateur/repositories/i_utilisateur_repository.dart';
import '../mock_data/utilisateurs_mock.dart';

class InMemoryUtilisateurRepository implements IUtilisateurRepository {
  final List<Utilisateur> _items = List.of(utilisateursMock);

  @override
  Future<void> enregistrer(Utilisateur u) async {
    final i = _items.indexWhere((x) => x.id == u.id);
    if (i >= 0) {
      _items[i] = u;
    } else {
      _items.add(u);
    }
  }

  @override
  Future<Utilisateur?> parEmail(String email) async {
    final e = email.trim().toLowerCase();
    try {
      return _items.firstWhere((u) => u.email.toLowerCase() == e);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Utilisateur?> parId(String id) async {
    try {
      return _items.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> supprimer(String id) async {
    _items.removeWhere((u) => u.id == id);
  }

  @override
  Future<List<Utilisateur>> tous() async => List.unmodifiable(_items);
}
