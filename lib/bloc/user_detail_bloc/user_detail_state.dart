part of 'user_detail_bloc.dart';

abstract class UserDetailState extends Equatable {
  const UserDetailState();

  @override
  List<Object> get props => [];
}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoading extends UserDetailState {}

class UserDetailError extends UserDetailState {
  final String message;

  UserDetailError(this.message);
}

class UserDetailFinished extends UserDetailState {
  final MongoUser user;

  UserDetailFinished(this.user);

  @override
  List<Object> get props => [
        user.uid,
        user.username,
        user.email,
        user.totalPoint,
        user.profilePicUrl,
        user.recordHistory
      ];
}
