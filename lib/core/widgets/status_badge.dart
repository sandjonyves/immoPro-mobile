import 'package:flutter/material.dart';

import '../../domain/maison/value_objects/statut_maison.dart';
import '../../domain/terrain/value_objects/statut_terrain.dart';
import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const StatusBadge._({
    required this.label,
    required this.bg,
    required this.fg,
  });

  factory StatusBadge.terrain(BuildContext context, StatutTerrain s) {
    final dark = AppColors.isDark(context);
    final (bg, fg) = switch (s) {
      StatutTerrain.disponible => dark
          ? (AppColors.statusDisponibleBgD, AppColors.statusDisponibleTextD)
          : (AppColors.statusDisponibleBgL, AppColors.statusDisponibleTextL),
      StatutTerrain.enNegociation =>
        dark ? (AppColors.statusNegoBgD, AppColors.statusNegoTextD) : (AppColors.statusNegoBgL, AppColors.statusNegoTextL),
      StatutTerrain.vendu =>
        dark ? (AppColors.statusVenduBgD, AppColors.statusVenduTextD) : (AppColors.statusVenduBgL, AppColors.statusVenduTextL),
      StatutTerrain.loue =>
        dark ? (AppColors.statusLoueBgD, AppColors.statusLoueTextD) : (AppColors.statusLoueBgL, AppColors.statusLoueTextL),
      StatutTerrain.travaux =>
        dark ? (AppColors.statusTravauxBgD, AppColors.statusTravauxTextD) : (AppColors.statusTravauxBgL, AppColors.statusTravauxTextL),
      StatutTerrain.archive =>
        dark ? (AppColors.statusArchiveBgD, AppColors.statusArchiveTextD) : (AppColors.statusArchiveBgL, AppColors.statusArchiveTextL),
    };
    return StatusBadge._(label: s.label, bg: bg, fg: fg);
  }

  factory StatusBadge.maison(BuildContext context, StatutMaison s) {
    final dark = AppColors.isDark(context);
    final (bg, fg) = switch (s) {
      StatutMaison.disponible => dark
          ? (AppColors.statusDisponibleBgD, AppColors.statusDisponibleTextD)
          : (AppColors.statusDisponibleBgL, AppColors.statusDisponibleTextL),
      StatutMaison.enNegociation =>
        dark ? (AppColors.statusNegoBgD, AppColors.statusNegoTextD) : (AppColors.statusNegoBgL, AppColors.statusNegoTextL),
      StatutMaison.vendu =>
        dark ? (AppColors.statusVenduBgD, AppColors.statusVenduTextD) : (AppColors.statusVenduBgL, AppColors.statusVenduTextL),
      StatutMaison.loue =>
        dark ? (AppColors.statusLoueBgD, AppColors.statusLoueTextD) : (AppColors.statusLoueBgL, AppColors.statusLoueTextL),
      StatutMaison.travaux =>
        dark ? (AppColors.statusTravauxBgD, AppColors.statusTravauxTextD) : (AppColors.statusTravauxBgL, AppColors.statusTravauxTextL),
    };
    return StatusBadge._(label: s.label, bg: bg, fg: fg);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
