part of 'ex_sounds_bloc.dart';

abstract class ExSoundsEvent extends Equatable {
  const ExSoundsEvent();

  @override
  List<Object> get props => [];
}

class HomeIsOpenedEvent extends ExSoundsEvent {}
