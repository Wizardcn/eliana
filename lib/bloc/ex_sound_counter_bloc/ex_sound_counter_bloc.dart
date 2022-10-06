import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
// import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
part 'ex_sound_counter_event.dart';
part 'ex_sound_counter_state.dart';

class ExSoundCounterBloc
    extends Bloc<ExSoundCounterEvent, ExSoundCounterState> {
  // FlutterSoundPlayer? _player = FlutterSoundPlayer();
  ExSoundCounterBloc() : super(ExSoundCounterState(index: 0)) {
    on<NextButtonIsPressed>((event, emit) async {
      // List<PlayedSound> ex_sounds = await DatabaseService().getPlayedSounds();
      if ((event.maxIndex - 1) == state.index) {
        emit(ExSoundCounterState(index: 0));
        FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: IosSound(1016),
            looping: false,
            volume: 0.1,
            asAlarm: false);
        // await _player!.openPlayer();
        // await _player!.startPlayer(
        //   fromURI:
        //       "https://botnoi-dictionary.s3.amazonaws.com:443/97b6a035519b962a9f6d848d82fec4cbf969afa538951d6c4cba8b5944bf24fb_09062022095755898338.mp3",
        // );
      } else {
        emit(state + ExSoundCounterState(index: 1));
        FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: IosSound(1016),
            looping: false,
            volume: 0.1,
            asAlarm: false);
        // await _player!.openPlayer();
        // await _player!.startPlayer(
        //   fromURI:
        //       "https://botnoi-dictionary.s3.amazonaws.com:443/97b6a035519b962a9f6d848d82fec4cbf969afa538951d6c4cba8b5944bf24fb_09062022095755898338.mp3",
        // );
      }
    });
    on<UploadAndNextButtonIsPressed>((event, emit) async {
      if (event.maxIndex == state.index) {
        emit(ExSoundCounterState(index: 0));
      } else {
        emit(state + ExSoundCounterState(index: 1));
      }
    });
  }
}
