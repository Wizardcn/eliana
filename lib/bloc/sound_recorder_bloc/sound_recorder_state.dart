part of 'sound_recorder_bloc.dart';

abstract class SoundRecorderState extends Equatable {
  const SoundRecorderState();

  @override
  List<Object> get props => [];
}

class SoundRecorderInitial extends SoundRecorderState {}

class SoundRecorderIsInited extends SoundRecorderState {}

class SoundRecorderReady extends SoundRecorderState {}

class SoundRecorderIsRecording extends SoundRecorderState {}

class SoundRecorderFinished extends SoundRecorderState {
  final String filename;

  SoundRecorderFinished(this.filename);
}
