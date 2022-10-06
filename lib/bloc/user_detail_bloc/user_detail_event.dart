part of 'user_detail_bloc.dart';

abstract class UserDetailEvent extends Equatable {
  const UserDetailEvent();

  @override
  List<Object> get props => [];
}

class AuthenticatedEvent extends UserDetailEvent {
  final String uid;

  AuthenticatedEvent(this.uid);
}
