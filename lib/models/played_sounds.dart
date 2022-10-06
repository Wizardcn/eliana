import 'dart:convert';

// map function in Dart is similar to forEach function in JS
List<PlayedSound> playedSoundsFromJson(String str) => List<PlayedSound>.from(
    json.decode(str).map((x) => PlayedSound.fromJson(x)));

String playedSoundsToJson(List<PlayedSound> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlayedSound {
  String playedSoundId;
  String playedSoundUrl;
  int count;
  int maxPoint;

  PlayedSound({
    required this.playedSoundId,
    required this.playedSoundUrl,
    required this.count,
    required this.maxPoint,
  });

  factory PlayedSound.fromJson(Map<String, dynamic> json) => PlayedSound(
        playedSoundId: json["played_sound_id"],
        playedSoundUrl: json["played_sound_url"],
        count: json["count"],
        maxPoint: json["max_point"],
      );

  Map<String, dynamic> toJson() => {
        "played_sound_id": playedSoundId,
        "played_sound_url": playedSoundUrl,
        "count": count,
        "max_point": maxPoint,
      };
}
