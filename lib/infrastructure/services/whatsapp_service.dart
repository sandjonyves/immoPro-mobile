import 'package:url_launcher/url_launcher.dart';

import '../../domain/whatsapp/ports/lanceur_whatsapp.dart';

class WhatsappService implements LanceurWhatsapp {
  @override
  Future<void> ouvrirUrl(String url) async {
    final uri = Uri.parse(url);
    final ok = await canLaunchUrl(uri);
    if (!ok) {
      throw Exception(
        'WhatsApp n\'est pas installé sur cet appareil. '
        'Veuillez l\'installer depuis le Play Store ou l\'App Store.',
      );
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
