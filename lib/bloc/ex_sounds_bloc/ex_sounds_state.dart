part of 'ex_sounds_bloc.dart';

abstract class ExSoundsState extends Equatable {
  const ExSoundsState();

  @override
  List<Object> get props => [];
}

class ExSoundsInitial extends ExSoundsState {}

class ExSoundsLoading extends ExSoundsState {}

class ExSoundsFinished extends ExSoundsState {
  final List<PlayedSound> ex_sounds;

  ExSoundsFinished(this.ex_sounds);

  @override
  List<Object> get props => [];
}

class ExSoundsError extends ExSoundsState {
  final String message;

  ExSoundsError(this.message);
}
