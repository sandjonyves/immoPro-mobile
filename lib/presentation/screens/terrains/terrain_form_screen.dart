import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:immopro/application/auth/auth_cubit.dart';
import 'package:immopro/application/auth/auth_state.dart';
import 'package:immopro/application/terrain/terrain_cubit.dart';
import 'package:immopro/application/terrain/terrain_state.dart';
import 'package:immopro/domain/location/value_objects/position_gps.dart';
import 'package:immopro/domain/terrain/use_cases/creer_terrain.dart';
import 'package:immopro/domain/terrain/use_cases/modifier_terrain.dart';
import 'package:immopro/domain/terrain/value_objects/borne.dart';
import 'package:immopro/domain/terrain/value_objects/statut_terrain.dart';

typedef LecturePosition = Future<PositionGps> Function();

class TerrainFormScreen extends StatefulWidget {
  final String? terrainId;
  final LecturePosition lecturePosition;

  const TerrainFormScreen({
    super.key,
    this.terrainId,
    required this.lecturePosition,
  });

  @override
  State<TerrainFormScreen> createState() => _TerrainFormScreenState();
}

class _TerrainFormScreenState extends State<TerrainFormScreen> {
  int _step = 0;

  final _titre = TextEditingController();
  final _desc = TextEditingController();
  final _quartier = TextEditingController();
  final _prix = TextEditingController();
  final _tf = TextEditingController();
  final _wa = TextEditingController(text: '237699000001');

  String _ville = 'Yaoundé';
  StatutTerrain _statut = StatutTerrain.disponible;

  final List<Borne> _bornes = [
    Borne(3.8480, 11.5021),
    Borne(3.8485, 11.5030),
    Borne(3.8478, 11.5040),
  ];

  final _villes = const ['Yaoundé', 'Douala', 'Bafoussam', 'Garoua', 'Ebolowa'];

  @override
  void initState() {
    super.initState();
    final id = widget.terrainId;
    if (id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await context.read<TerrainCubit>().chargerDetail(id);
        if (!mounted) return;
        final s = context.read<TerrainCubit>().state;
        if (s is TerrainDetailLoaded) {
          final t = s.terrain;
          _titre.text = t.titre;
          _desc.text = t.description;
          _quartier.text = t.quartier;
          _prix.text = t.prix.toStringAsFixed(0);
          _tf.text = t.titreFoncier;
          _wa.text = t.agentWhatsapp;
          _ville = t.ville;
          _statut = t.statut == StatutTerrain.archive
              ? StatutTerrain.disponible
              : t.statut;
          setState(() {
            _bornes
              ..clear()
              ..addAll(t.bornes);
          });
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
    _tf.dispose();
    _wa.dispose();
    super.dispose();
  }

  Future<void> _gpsPour(int index) async {
    try {
      final p = await widget.lecturePosition();
      setState(() {
        _bornes[index] = Borne(p.latitude, p.longitude);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<void> _sauver() async {
    final auth = context.read<AuthCubit>().state;
    if (auth is! AuthAuthenticated) return;

    final prix = double.tryParse(_prix.text.replaceAll(' ', ''));
    if (prix == null || prix <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prix invalide')),
      );
      return;
    }
    if (_bornes.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Au moins 3 bornes GPS')),
      );
      return;
    }

    final cubit = context.read<TerrainCubit>();
    if (widget.terrainId == null) {
      await cubit.creer(
        CreerTerrainInput(
          titre: _titre.text,
          bornes: List.of(_bornes),
          statut: _statut,
          prix: prix,
          ville: _ville,
          quartier: _quartier.text,
          description: _desc.text,
          titreFoncier: _tf.text,
          agentId: auth.utilisateur.id,
          agentWhatsapp: _wa.text.replaceAll(' ', ''),
        ),
      );
    } else {
      await cubit.modifier(
        ModifierTerrainInput(
          id: widget.terrainId!,
          titre: _titre.text,
          bornes: List.of(_bornes),
          statut: _statut,
          prix: prix,
          ville: _ville,
          quartier: _quartier.text,
          description: _desc.text,
          titreFoncier: _tf.text,
          agentWhatsapp: _wa.text.replaceAll(' ', ''),
        ),
      );
    }
    if (!mounted) return;
    final s = context.read<TerrainCubit>().state;
    if (s is TerrainError) {
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
        title: Text(widget.terrainId == null ? 'Nouveau terrain' : 'Modifier'),
      ),
      body: Stepper(
        currentStep: _step,
        onStepContinue: () {
          if (_step < 2) {
            setState(() => _step++);
          } else {
            _sauver();
          }
        },
        onStepCancel: () {
          if (_step > 0) {
            setState(() => _step--);
          } else {
            context.pop();
          }
        },
        steps: [
          Step(
            title: const Text('Informations'),
            content: Column(
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
                DropdownButtonFormField<String>(
                  key: ValueKey(_ville),
                  initialValue: _ville,
                  items: _villes
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
                  children: StatutTerrain.values
                      .where((s) => s != StatutTerrain.archive)
                      .map((s) {
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
                  controller: _tf,
                  decoration: const InputDecoration(labelText: 'Titre foncier'),
                ),
                TextField(
                  controller: _wa,
                  decoration:
                      const InputDecoration(labelText: 'WhatsApp agent *'),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Bornes GPS'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${_bornes.length} borne(s)',
                  textAlign: TextAlign.center,
                ),
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _bornes.length,
                  onReorder: (a, b) {
                    setState(() {
                      final x = _bornes.removeAt(a);
                      _bornes.insert(b > a ? b - 1 : b, x);
                    });
                  },
                  itemBuilder: (_, i) {
                    final b = _bornes[i];
                    return ListTile(
                      key: ValueKey('borne$i-${b.latitude}-${b.longitude}'),
                      title: Text('Borne $i'),
                      subtitle: Text(
                        '${b.latitude.toStringAsFixed(4)}, ${b.longitude.toStringAsFixed(4)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.my_location),
                            onPressed: () => _gpsPour(i),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: _bornes.length <= 3
                                ? null
                                : () => setState(() => _bornes.removeAt(i)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                TextButton.icon(
                  onPressed: () async {
                    try {
                      final p = await widget.lecturePosition();
                      if (!context.mounted) return;
                      setState(() => _bornes.add(Borne(p.latitude, p.longitude)));
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$e')),
                      );
                    }
                  },
                  icon: const Icon(Icons.add_location_alt),
                  label: const Text('Ajouter une borne'),
                ),
              ],
            ),
          ),
          const Step(
            title: Text('Médias'),
            content: Text(
              'Démo : les médias seront envoyés au backend dans une version ultérieure.',
            ),
          ),
        ],
      ),
    );
  }
}
