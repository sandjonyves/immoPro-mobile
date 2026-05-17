import 'package:equatable/equatable.dart';

import '../../domain/maison/entities/maison.dart';

sealed class MaisonState extends Equatable {
  const MaisonState();
  @override
  List<Object?> get props => [];
}

class MaisonInitial extends MaisonState {
  const MaisonInitial();
}

class MaisonLoading extends MaisonState {
  const MaisonLoading();
}

class MaisonListLoaded extends MaisonState {
  final List<Maison> maisons;
  const MaisonListLoaded(this.maisons);
  @override
  List<Object?> get props => [maisons];
}

class MaisonDetailLoaded extends MaisonState {
  final Maison maison;
  const MaisonDetailLoaded(this.maison);
  @override
  List<Object?> get props => [maison];
}

class MaisonError extends MaisonState {
  final String message;
  const MaisonError(this.message);
  @override
  List<Object?> get props => [message];
}
