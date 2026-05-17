import 'package:equatable/equatable.dart';

class FavorisState extends Equatable {
  final Set<String> terrains;
  final Set<String> maisons;

  const FavorisState({
    required this.terrains,
    required this.maisons,
  });

  FavorisState copyWith({
    Set<String>? terrains,
    Set<String>? maisons,
  }) {
    return FavorisState(
      terrains: terrains ?? this.terrains,
      maisons: maisons ?? this.maisons,
    );
  }

  @override
  List<Object?> get props => [terrains, maisons];
}
