import '../../shared/errors/domain_error.dart';
import '../../terrain/repositories/i_terrain_repository.dart';
import '../ports/lanceur_whatsapp.dart';
import '../value_objects/whatsapp_message.dart';

class ContacterPourTerrain {
  final LanceurWhatsapp _launcher;
  final ITerrainRepository _terrainRepository;

  const ContacterPourTerrain(this._launcher, this._terrainRepository);

  Future<void> execute({
    required String terrainId,
    required String? nomClient,
  }) async {
    final terrain = await _terrainRepository.parId(terrainId);
    if (terrain == null) {
      throw const DomainError('Terrain introuvable.');
    }

    final message = WhatsappMessage.pourTerrain(
      terrain: terrain,
      nomClient: nomClient,
    );

    await _launcher.ouvrirUrl(message.url);
  }
}
