part of 'ex_sound_player_bloc.dart';

abstract class ExSoundPlayerEvent extends Equatable {
  const ExSoundPlayerEvent();

  @override
  List<Object> get props => [];
}

class OpenExPlayerEvent extends ExSoundPlayerEvent {}

class StartExPlayerIsPressed extends ExSoundPlayerEvent {
  final String url;

  StartExPlayerIsPressed(this.url);
}

class StopExPlayerIsPressed extends ExSoundPlayerEvent {}
