part of 'ex_sound_counter_bloc.dart';

abstract class ExSoundCounterEvent {}

class NextButtonIsPressed extends ExSoundCounterEvent {
  final int maxIndex;

  NextButtonIsPressed({required this.maxIndex});
}

class UploadAndNextButtonIsPressed extends ExSoundCounterEvent {
  final int maxIndex;

  UploadAndNextButtonIsPressed({required this.maxIndex});
}
