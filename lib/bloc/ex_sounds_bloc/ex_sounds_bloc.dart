import 'package:bloc/bloc.dart';
import 'package:eliana/models/played_sounds.dart';
import 'package:eliana/services/database.dart';
import 'package:equatable/equatable.dart';

part 'ex_sounds_event.dart';
part 'ex_sounds_state.dart';

class ExSoundsBloc extends Bloc<ExSoundsEvent, ExSoundsState> {
  ExSoundsBloc() : super(ExSoundsInitial()) {
    on<HomeIsOpenedEvent>((event, emit) async {
      emit(ExSoundsLoading());
      try {
        List<PlayedSound> ex_sounds = await DatabaseService().getPlayedSounds();
        emit(ExSoundsFinished(ex_sounds));
      } catch (e) {
        emit(ExSoundsError(e.toString()));
      }
    });
  }
}
