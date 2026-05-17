import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:immopro/application/auth/auth_cubit.dart';
import 'package:immopro/application/auth/auth_state.dart';
import 'package:immopro/application/maison/maison_cubit.dart';
import 'package:immopro/application/maison/maison_state.dart';
import 'package:immopro/domain/location/value_objects/position_gps.dart';
import 'package:immopro/domain/maison/use_cases/creer_maison.dart';
import 'package:immopro/domain/maison/use_cases/modifier_maison.dart';
import 'package:immopro/domain/maison/value_objects/localisation.dart';
import 'package:immopro/domain/maison/value_objects/statut_maison.dart';
import 'package:immopro/domain/maison/value_objects/type_maison.dart';

typedef LecturePositionMaison = Future<PositionGps> Function();

class MaisonFormScreen extends StatefulWidget {
  final String? maisonId;
  final LecturePositionMaison lecturePosition;

  const MaisonFormScreen({
    super.key,
    this.maisonId,
    required this.lecturePosition,
  });

  @override
  State<MaisonFormScreen> createState() => _MaisonFormScreenState();
}

class _MaisonFormScreenState extends State<MaisonFormScreen> {
  final _titre = TextEditingController();
  final _desc = TextEditingController();
  final _quartier = TextEditingController();
  final _prix = TextEditingController();
  final _ch = TextEditingController(text: '3');
  final _sdb = TextEditingController(text: '2');
  final _et = TextEditingController(text: '1');
  final _surf = TextEditingController(text: '120');
  final _wa = TextEditingController(text: '237699000001');

  String _ville = 'Yaoundé';
  TypeMaison _type = TypeMaison.villa;
  StatutMaison _statut = StatutMaison.disponible;
  Localisation _loc = Localisation(3.8667, 11.5167);

  @override
  void initState() {
    super.initState();
    final id = widget.maisonId;
    if (id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await context.read<MaisonCubit>().chargerDetail(id);
        if (!mounted) return;
        final s = context.read<MaisonCubit>().state;
        if (s is MaisonDetailLoaded) {
          final m = s.maison;
          _titre.text = m.titre;
          _desc.text = m.description;
          _quartier.text = m.quartier;
          _prix.text = m.prix.toStringAsFixed(0);
          _ch.text = '${m.chambres}';
          _sdb.text = '${m.sallesDeBain}';
          _et.text = '${m.etages}';
          _surf.text = m.surfaceHabitableM2.toStringAsFixed(0);
          _wa.text = m.agentWhatsapp;
          _ville = m.ville;
          _type = m.type;
          _statut = m.statut;
          _loc = m.localisation;
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _titre.dispose();
    _desc.dispose();
    _quartier.dispose();
    _prix.dispose();
    _ch.dispose();
    _sdb.dispose();
    _et.dispose();
    _surf.dispose();
    _wa.dispose();
    super.dispose();
  }

  Future<void> _gps() async {
    try {
      final p = await widget.lecturePosition();
      setState(() => _loc = Localisation(p.latitude, p.longitude));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<void> _save() async {
    final auth = context.read<AuthCubit>().state;
    if (auth is! AuthAuthenticated) return;
    final prix = double.tryParse(_prix.text.replaceAll(' ', ''));
    final hab = double.tryParse(_surf.text.replaceAll(' ', ''));
    final ch = int.tryParse(_ch.text);
    final sdb = int.tryParse(_sdb.text);
    final et = int.tryParse(_et.text);
    if (prix == null || hab == null || ch == null || sdb == null || et == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Champs numériques invalides')),
      );
      return;
    }

    final cubit = context.read<MaisonCubit>();
    if (widget.maisonId == null) {
      await cubit.creer(
        CreerMaisonInput(
          titre: _titre.text,
          localisation: _loc,
          type: _type,
          statut: _statut,
          prix: prix,
          ville: _ville,
          quartier: _quartier.text,
          description: _desc.text,
          chambres: ch,
          sallesDeBain: sdb,
          etages: et,
          surfaceHabitableM2: hab,
          agentId: auth.utilisateur.id,
          agentWhatsapp: _wa.text.replaceAll(' ', ''),
        ),
      );
    } else {
      await cubit.modifier(
        ModifierMaisonInput(
          id: widget.maisonId!,
          titre: _titre.text,
          localisation: _loc,
          type: _type,
          statut: _statut,
          prix: prix,
          ville: _ville,
          quartier: _quartier.text,
          description: _desc.text,
          chambres: ch,
          sallesDeBain: sdb,
          etages: et,
          surfaceHabitableM2: hab,
          agentWhatsapp: _wa.text.replaceAll(' ', ''),
        ),
      );
    }
    if (!mounted) return;
    final s = context.read<MaisonCubit>().state;
    if (s is MaisonError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.message)),
      );
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.maisonId == null ? 'Nouvelle maison' : 'Modifier'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titre,
            decoration: const InputDecoration(labelText: 'Titre *'),
          ),
          TextField(
            controller: _desc,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          DropdownButtonFormField<TypeMaison>(
            key: ValueKey(_type),
            initialValue: _type,
            items: TypeMaison.values
                .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                .toList(),
            onChanged: (v) => setState(() => _type = v ?? _type),
            decoration: const InputDecoration(labelText: 'Type *'),
          ),
          DropdownButtonFormField<String>(
            key: ValueKey(_ville),
            initialValue: _ville,
            items: ['Yaoundé', 'Douala', 'Bafoussam']
                .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                .toList(),
            onChanged: (v) => setState(() => _ville = v ?? _ville),
            decoration: const InputDecoration(labelText: 'Ville *'),
          ),
          TextField(
            controller: _quartier,
            decoration: const InputDecoration(labelText: 'Quartier *'),
          ),
          Wrap(
            spacing: 8,
            children: StatutMaison.values.map((s) {
              return ChoiceChip(
                label: Text(s.label),
                selected: _statut == s,
                onSelected: (_) => setState(() => _statut = s),
              );
            }).toList(),
          ),
          TextField(
            controller: _prix,
            decoration: const InputDecoration(labelText: 'Prix XAF *'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _ch,
            decoration: const InputDecoration(labelText: 'Chambres'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _sdb,
            decoration: const InputDecoration(labelText: 'Salles de bain'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _et,
            decoration: const InputDecoration(labelText: 'Étages'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _surf,
            decoration: const InputDecoration(labelText: 'Surface habitable m² *'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _wa,
            decoration: const InputDecoration(labelText: 'WhatsApp agent *'),
          ),
          ListTile(
            title: const Text('Position GPS'),
            subtitle: Text(
              '${_loc.latitude.toStringAsFixed(4)}, ${_loc.longitude.toStringAsFixed(4)}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: _gps,
            ),
          ),
          FilledButton(
            onPressed: _save,
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
