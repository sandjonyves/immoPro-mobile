import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryLight = Color(0xFF1B4FFF);
  static const Color primaryHoverLight = Color(0xFF1640D6);
  static const Color primaryLightBg = Color(0xFFE8F0FE);
  static const Color primaryDark = Color(0xFF3B6FFF);
  static const Color primaryHoverDark = Color(0xFF5A87FF);
  static const Color primaryDarkBg = Color(0xFF1E2A4A);

  static const Color bgPageL = Color(0xFFF8FAFC);
  static const Color bgCardL = Color(0xFFFFFFFF);
  static const Color bgSidebarL = Color(0xFF0F172A);
  static const Color bgInputL = Color(0xFFFFFFFF);
  static const Color bgHoverL = Color(0xFFF1F5F9);
  static const Color bgMutedL = Color(0xFFF1F5F9);

  static const Color bgPageD = Color(0xFF0B0F19);
  static const Color bgCardD = Color(0xFF141A27);
  static const Color bgSidebarD = Color(0xFF0D1117);
  static const Color bgInputD = Color(0xFF1C2333);
  static const Color bgHoverD = Color(0xFF1C2333);
  static const Color bgMutedD = Color(0xFF1C2333);

  static const Color textPrimaryL = Color(0xFF0F172A);
  static const Color textSecondaryL = Color(0xFF64748B);
  static const Color textMutedL = Color(0xFF94A3B8);

  static const Color textPrimaryD = Color(0xFFF1F5F9);
  static const Color textSecondaryD = Color(0xFF94A3B8);
  static const Color textMutedD = Color(0xFF64748B);

  static const Color borderL = Color(0xFFE2E8F0);
  static const Color borderD = Color(0xFF1E2A3A);
  static const Color borderFocusL = Color(0xFF1B4FFF);
  static const Color borderFocusD = Color(0xFF3B6FFF);

  static const Color statusDisponibleBgL = Color(0xFFDCFCE7);
  static const Color statusDisponibleTextL = Color(0xFF166534);
  static const Color statusNegoBgL = Color(0xFFFEF9C3);
  static const Color statusNegoTextL = Color(0xFF854D0E);
  static const Color statusVenduBgL = Color(0xFFFEE2E2);
  static const Color statusVenduTextL = Color(0xFF991B1B);
  static const Color statusLoueBgL = Color(0xFFEDE9FE);
  static const Color statusLoueTextL = Color(0xFF5B21B6);
  static const Color statusTravauxBgL = Color(0xFFF1F5F9);
  static const Color statusTravauxTextL = Color(0xFF475569);
  static const Color statusArchiveBgL = Color(0xFFF8FAFC);
  static const Color statusArchiveTextL = Color(0xFF94A3B8);

  static const Color statusDisponibleBgD = Color(0xFF052E16);
  static const Color statusDisponibleTextD = Color(0xFF4ADE80);
  static const Color statusNegoBgD = Color(0xFF1C1500);
  static const Color statusNegoTextD = Color(0xFFFCD34D);
  static const Color statusVenduBgD = Color(0xFF1C0A0A);
  static const Color statusVenduTextD = Color(0xFFF87171);
  static const Color statusLoueBgD = Color(0xFF150D27);
  static const Color statusLoueTextD = Color(0xFFC4B5FD);
  static const Color statusTravauxBgD = Color(0xFF1C2333);
  static const Color statusTravauxTextD = Color(0xFF94A3B8);
  static const Color statusArchiveBgD = Color(0xFF141A27);
  static const Color statusArchiveTextD = Color(0xFF64748B);

  static const Color mapDisponibleL = Color(0xFF10B981);
  static const Color mapNegoL = Color(0xFFF59E0B);
  static const Color mapVenduL = Color(0xFFEF4444);
  static const Color mapLoueL = Color(0xFF8B5CF6);
  static const Color mapArchiveL = Color(0xFF94A3B8);
  static const Color mapDisponibleD = Color(0xFF34D399);
  static const Color mapNegoD = Color(0xFFFCD34D);
  static const Color mapVenduD = Color(0xFFF87171);
  static const Color mapLoueD = Color(0xFFA78BFA);
  static const Color mapArchiveD = Color(0xFF64748B);

  static const Color whatsappGreen = Color(0xFF25D366);
  static const Color whatsappDark = Color(0xFF128C7E);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}
