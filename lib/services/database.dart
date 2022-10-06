import 'package:eliana/models/mongo_users.dart';
import 'dart:convert';
import 'package:eliana/models/played_sounds.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  late List<PlayedSound> _playedSoundsFromAPI;
  late MongoUser _userFromAPI;

  Future<List<PlayedSound>> getPlayedSounds() async {
    var url = Uri.parse("https://domain.com/service/played_sounds/");
    var response = await http.get(url);
    _playedSoundsFromAPI = playedSoundsFromJson(response.body);
    return _playedSoundsFromAPI;
  }

  Future<MongoUser> getUserDetail() async {
    var url = Uri.parse("https://domain.com/service/users/$uid");
    var response = await http.get(url);
    _userFromAPI = userFromJson(response.body);
    return _userFromAPI;
  }

  Future postRecordedSound(String playedSoundId, String recordedUrl) async {
    var url = Uri.parse('https://domain.com/service/recorded_sounds/');
    var body = {
      "played_sound_id": playedSoundId,
      "recorded_url": recordedUrl,
      "uid": uid
    };
    var headers = {
      "accept": "application/json",
      "Content-Type": "application/json"
    };
    http.Response response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    return response.body;
  }

  Future createUserDetail(String username, String email, String password,
      String profilePicUrl) async {
    var url = Uri.parse('https://domain.com/service/users/');
    var body = {
      "uid": uid,
      "username": username,
      "email": email,
      "password": password,
      "profile_pic_url": profilePicUrl
    };
    var headers = {
      "accept": "application/json",
      "Content-Type": "application/json"
    };
    http.Response response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    return response.body;
  }
}
