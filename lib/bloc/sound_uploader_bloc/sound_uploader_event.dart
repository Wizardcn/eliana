part of 'sound_uploader_bloc.dart';

abstract class SoundUploaderEvent extends Equatable {
  const SoundUploaderEvent();

  @override
  List<Object> get props => [];
}

class SoundUploaderPressed extends SoundUploaderEvent {
  final String uid;
  final String playedSoundId;
  final String fileName;

  SoundUploaderPressed({
    required this.uid,
    required this.playedSoundId,
    required this.fileName,
  });
}

class ResetSoundUploader extends SoundUploaderEvent {}

class StopRecorderPressed extends SoundUploaderEvent {}
