import 'package:bloc/bloc.dart';
import 'package:eliana/models/mongo_users.dart';
import 'package:eliana/services/database.dart';
import 'package:equatable/equatable.dart';

part 'user_detail_event.dart';
part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  UserDetailBloc() : super(UserDetailInitial()) {
    on<AuthenticatedEvent>((event, emit) async {
      emit(UserDetailLoading());
      try {
        MongoUser user = await DatabaseService(uid: event.uid).getUserDetail();
        emit(UserDetailFinished(user));
      } catch (e) {
        emit(UserDetailError(e.toString()));
        return;
      }
    });
  }
}
