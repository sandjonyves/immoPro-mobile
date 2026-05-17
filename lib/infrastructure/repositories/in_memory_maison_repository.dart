import '../../domain/maison/entities/maison.dart';
import '../../domain/maison/repositories/i_maison_repository.dart';
import '../mock_data/maisons_mock.dart';

class InMemoryMaisonRepository implements IMaisonRepository {
  final List<Maison> _items = List.of(maisonsMock);

  @override
  Future<void> enregistrer(Maison maison) async {
    final i = _items.indexWhere((m) => m.id == maison.id);
    if (i >= 0) {
      _items[i] = maison;
    } else {
      _items.add(maison);
    }
  }

  @override
  Future<Maison?> parId(String id) async {
    try {
      return _items.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> supprimer(String id) async {
    _items.removeWhere((m) => m.id == id);
  }

  @override
  Future<List<Maison>> tous() async => List.unmodifiable(_items);
}
