part of 'ex_sound_counter_bloc.dart';

class ExSoundCounterState extends Equatable {
  final int index;
  ExSoundCounterState({required this.index});

  ExSoundCounterState operator +(ExSoundCounterState state) {
    return ExSoundCounterState(index: this.index + state.index);
  }

  @override
  List<Object> get props => [index];
}
