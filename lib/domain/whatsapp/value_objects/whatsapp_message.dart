import '../../audit/entities/service_audit.dart';
import '../../maison/entities/maison.dart';
import '../../terrain/entities/terrain.dart';
import '../../shared/formatage_prix.dart';

class WhatsappMessage {
  final String numero;
  final String messageEncode;

  const WhatsappMessage._({
    required this.numero,
    required this.messageEncode,
  });

  factory WhatsappMessage.pourTerrain({
    required Terrain terrain,
    required String? nomClient,
  }) {
    final msg = '''Bonjour ImmoPro 👋

Je suis intéressé(e) par le terrain suivant :

🏷️ *${terrain.titre}*
📍 ${terrain.quartier}, ${terrain.ville}
📐 Surface : ${terrain.surfaceM2.formate}
💰 Prix : ${FormatagePrix.xaf(terrain.prix)}
📋 Réf. : ${terrain.id}

${nomClient != null ? 'Mon nom : $nomClient\n' : ''}Pourriez-vous me donner plus d'informations et organiser une visite ?

Merci.''';

    return WhatsappMessage._(
      numero: terrain.agentWhatsapp,
      messageEncode: Uri.encodeComponent(msg),
    );
  }

  factory WhatsappMessage.pourMaison({
    required Maison maison,
    required String? nomClient,
  }) {
    final typeLabel = maison.type.label;
    final msg = '''Bonjour ImmoPro 👋

Je suis intéressé(e) par le bien suivant :

🏠 *${maison.titre}*
🏷️ Type : $typeLabel
📍 ${maison.quartier}, ${maison.ville}
📐 Surface : ${maison.surfaceHabitableM2.toStringAsFixed(0)} m²
🛏️ ${maison.chambres} chambre(s) · 🚿 ${maison.sallesDeBain} SDB
💰 Prix : ${FormatagePrix.xaf(maison.prix)}
📋 Réf. : ${maison.id}

${nomClient != null ? 'Mon nom : $nomClient\n' : ''}Je souhaite obtenir plus d'informations et si possible visiter ce bien.

Merci.''';

    return WhatsappMessage._(
      numero: maison.agentWhatsapp,
      messageEncode: Uri.encodeComponent(msg),
    );
  }

  factory WhatsappMessage.pourAudit({
    required ServiceAudit service,
    required String? nomClient,
    required String? descriptionBien,
  }) {
    final msg = '''Bonjour ImmoPro 👋

Je souhaite bénéficier du service suivant :

🔍 *${service.titre}*
📂 Catégorie : ${service.categorie.label}
⏱️ Durée estimée : ${service.dureeEstimee}
💰 Tarif indicatif : ${service.tarif.affichage}

${nomClient != null ? '👤 Mon nom : $nomClient\n' : ''}${descriptionBien != null && descriptionBien.isNotEmpty ? '📋 Description du bien concerné :\n$descriptionBien\n' : ''}Pourriez-vous me contacter pour démarrer ce service ?

Merci.''';

    return WhatsappMessage._(
      numero: service.whatsappNumero,
      messageEncode: Uri.encodeComponent(msg),
    );
  }

  String get url => 'https://wa.me/$numero?text=$messageEncode';
}
