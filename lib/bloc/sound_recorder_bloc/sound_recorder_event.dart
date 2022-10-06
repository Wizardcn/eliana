part of 'sound_recorder_bloc.dart';

abstract class SoundRecorderEvent extends Equatable {
  const SoundRecorderEvent();

  @override
  List<Object> get props => [];
}

class OpenRecorderEvent extends SoundRecorderEvent {}

class UserPressedExButtonEvent extends SoundRecorderEvent {}

class StartRecorderIsPressed extends SoundRecorderEvent {}

class StopRecorderIsPressed extends SoundRecorderEvent {}

class ResetRecorderEvent extends SoundRecorderEvent {}
