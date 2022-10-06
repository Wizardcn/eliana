part of 'ex_sound_player_bloc.dart';

abstract class ExSoundPlayerState extends Equatable {
  const ExSoundPlayerState();

  @override
  List<Object> get props => [];
}

class ExSoundPlayerInitial extends ExSoundPlayerState {}

class ExSoundPlayerIsInited extends ExSoundPlayerState {}

class ExSoundPlayerIsPlaying extends ExSoundPlayerState {}

class ExSoundPlayerFinished extends ExSoundPlayerState {}
