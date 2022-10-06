part of 'recorded_sound_player_bloc.dart';

abstract class RecordedSoundPlayerState extends Equatable {
  const RecordedSoundPlayerState();

  @override
  List<Object> get props => [];
}

class RecordedSoundPlayerInitial extends RecordedSoundPlayerState {}

class RecordedSoundPlayerIsInited extends RecordedSoundPlayerState {}

class RecordedSoundPlayerIsPlaying extends RecordedSoundPlayerState {}

class RecordedSoundPlayerFinished extends RecordedSoundPlayerState {}
