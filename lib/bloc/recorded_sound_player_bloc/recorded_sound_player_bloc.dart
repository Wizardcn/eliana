import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sound/flutter_sound.dart';

part 'recorded_sound_player_event.dart';
part 'recorded_sound_player_state.dart';

class RecordedSoundPlayerBloc
    extends Bloc<RecordedSoundPlayerEvent, RecordedSoundPlayerState> {
  FlutterSoundPlayer? _player = FlutterSoundPlayer();
  RecordedSoundPlayerBloc() : super(RecordedSoundPlayerInitial()) {
    on<OpenRecordedPlayerEvent>((event, emit) async {
      await _player!
          .openPlayer()
          .whenComplete(() => emit(RecordedSoundPlayerIsInited()));
    });

    on<StartRecordedPlayerIsPressed>((event, emit) async {
      emit(RecordedSoundPlayerIsPlaying());
      Duration? duration = await _player!.startPlayer(
        fromURI: event.filename,
      );
      await Future.delayed(duration!);
      emit(RecordedSoundPlayerFinished());
    });

    on<StopRecordedPlayerIsPressed>((event, emit) async {
      await _player!
          .stopPlayer()
          .whenComplete(() => emit(RecordedSoundPlayerFinished()));
    });
  }
}
