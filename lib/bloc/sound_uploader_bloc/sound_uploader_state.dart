part of 'sound_uploader_bloc.dart';

abstract class SoundUploaderState extends Equatable {
  const SoundUploaderState();

  @override
  List<Object> get props => [];
}

class SoundUploaderInitial extends SoundUploaderState {}

class SoundUploaderReady extends SoundUploaderState {}

class SoundUploadingState extends SoundUploaderState {}

class SoundUploadAccepted extends SoundUploaderState {}

class SoundUploadError extends SoundUploadingState {
  final String message;

  SoundUploadError(this.message);
}
