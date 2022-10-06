import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
part 'sound_recorder_event.dart';
part 'sound_recorder_state.dart';

const theSource = AudioSource.microphone;

class SoundRecorderBloc extends Bloc<SoundRecorderEvent, SoundRecorderState> {
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  Codec _codec = Codec.aacMP4;
  SoundRecorderBloc() : super(SoundRecorderInitial()) {
    on<OpenRecorderEvent>((event, emit) async {
      if (!kIsWeb) {
        var status = await Permission.microphone.request();
        if (status != PermissionStatus.granted) {
          throw RecordingPermissionException(
              'Microphone permission not granted');
        }
      }
      await _recorder!.openRecorder();
      if (!await _recorder!.isEncoderSupported(_codec) && kIsWeb) {
        if (!await _recorder!.isEncoderSupported(_codec) && kIsWeb) {
          // _mRecorderIsInited = true;
          emit(SoundRecorderIsInited());
          return;
        }
      }
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth |
                AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));

      emit(SoundRecorderIsInited());
    });

    on<StartRecorderIsPressed>((event, emit) {
      dynamic time = DateTime.now()
          .toString()
          .substring(0, 19)
          .replaceAll(RegExp(r'[^0-9]'), '');
      emit(SoundRecorderIsRecording());
      _recorder!.startRecorder(
        toFile: '$time.mp4',
        codec: _codec,
        audioSource: theSource,
      );
    });

    on<StopRecorderIsPressed>((event, emit) async {
      await _recorder!.stopRecorder().then((value) {
        emit(SoundRecorderFinished(value.toString()));
      });
    });

    on<ResetRecorderEvent>((event, emit) {
      emit(SoundRecorderIsInited());
    });

    on<UserPressedExButtonEvent>((event, emit) {
      emit(SoundRecorderReady());
    });
  }
}
