part of 'recorded_sound_player_bloc.dart';

abstract class RecordedSoundPlayerEvent extends Equatable {
  const RecordedSoundPlayerEvent();

  @override
  List<Object> get props => [];
}

class OpenRecordedPlayerEvent extends RecordedSoundPlayerEvent {}

class StartRecordedPlayerIsPressed extends RecordedSoundPlayerEvent {
  final String filename;

  StartRecordedPlayerIsPressed(this.filename);
}

class StopRecordedPlayerIsPressed extends RecordedSoundPlayerEvent {}
