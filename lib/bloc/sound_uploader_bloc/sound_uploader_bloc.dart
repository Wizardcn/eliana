import 'package:bloc/bloc.dart';
import 'package:eliana/services/database.dart';
import 'package:eliana/services/storage.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
// import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

part 'sound_uploader_event.dart';
part 'sound_uploader_state.dart';

class SoundUploaderBloc extends Bloc<SoundUploaderEvent, SoundUploaderState> {
  // FlutterSoundPlayer? _player = FlutterSoundPlayer();

  SoundUploaderBloc() : super(SoundUploaderInitial()) {
    on<SoundUploaderPressed>((event, emit) async {
      emit(SoundUploadingState());
      try {
        String? recordedSoundUrl =
            await StorageService().upload(File(event.fileName));
        DatabaseService(uid: event.uid)
            .postRecordedSound(event.playedSoundId, recordedSoundUrl!);
        emit(SoundUploadAccepted());
        FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: IosSounds.sentMessage,
            looping: false,
            volume: 0.1,
            asAlarm: false);
        // await _player!.openPlayer();
        // await _player!.startPlayer(
        //   fromURI:
        //       "https://botnoi-dictionary.s3.amazonaws.com:443/764650f8ddbc55be0cb16767b90f274b6195ade830d73205fa156e75115a4659_08262022060539279500.mp3",
        // );
      } catch (e) {
        emit(SoundUploadError(e.toString()));
      }
    });

    on<StopRecorderPressed>((event, emit) {
      emit(SoundUploaderReady());
    });

    on<ResetSoundUploader>((event, emit) {
      emit(SoundUploaderInitial());
    });
  }
}
