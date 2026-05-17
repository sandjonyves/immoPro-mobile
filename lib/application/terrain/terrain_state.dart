import 'package:equatable/equatable.dart';

import '../../domain/terrain/entities/terrain.dart';

sealed class TerrainState extends Equatable {
  const TerrainState();
  @override
  List<Object?> get props => [];
}

class TerrainInitial extends TerrainState {
  const TerrainInitial();
}

class TerrainLoading extends TerrainState {
  const TerrainLoading();
}

class TerrainListLoaded extends TerrainState {
  final List<Terrain> terrains;
  const TerrainListLoaded(this.terrains);
  @override
  List<Object?> get props => [terrains];
}

class TerrainDetailLoaded extends TerrainState {
  final Terrain terrain;
  const TerrainDetailLoaded(this.terrain);
  @override
  List<Object?> get props => [terrain];
}

class TerrainError extends TerrainState {
  final String message;
  const TerrainError(this.message);
  @override
  List<Object?> get props => [message];
}
