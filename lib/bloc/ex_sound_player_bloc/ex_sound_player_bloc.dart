import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sound/flutter_sound.dart';

part 'ex_sound_player_event.dart';
part 'ex_sound_player_state.dart';

class ExSoundPlayerBloc extends Bloc<ExSoundPlayerEvent, ExSoundPlayerState> {
  FlutterSoundPlayer? _player = FlutterSoundPlayer();
  ExSoundPlayerBloc() : super(ExSoundPlayerInitial()) {
    on<OpenExPlayerEvent>((event, emit) async {
      await _player!
          .openPlayer()
          .whenComplete(() => emit(ExSoundPlayerIsInited()));
    });

    on<StartExPlayerIsPressed>((event, emit) async {
      emit(ExSoundPlayerIsPlaying());
      Duration? duration = await _player!.startPlayer(
        fromURI: event.url,
      );
      await Future.delayed(duration!);
      emit(ExSoundPlayerFinished());
    });

    on<StopExPlayerIsPressed>((event, emit) async {
      await _player!
          .stopPlayer()
          .whenComplete(() => emit(ExSoundPlayerFinished()));
    });
  }
}
